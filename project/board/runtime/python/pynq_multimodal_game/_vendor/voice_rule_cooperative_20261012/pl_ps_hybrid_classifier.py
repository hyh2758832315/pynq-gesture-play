#!/usr/bin/env python3
"""Offline golden model for the balanced PL-feature + PS-classifier design.

This module deliberately does not consume the existing 12-feature PS model.
It models only quantities that the planned PL front end can stream to the PS:

* frame mean-square power;
* frame zero-crossing ratio;
* four broad-band FFT magnitude sums;
* total FFT magnitude and its first frequency moment.

The PS aggregates those frame records over one recording and performs the
small centroid classifier plus the conservative ``none`` gate.  The floating
point implementation is the algorithmic golden.  Fixed-point RTL equivalence
is a later, separate acceptance boundary.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import wave
from pathlib import Path
from typing import Dict, Iterable, List, Sequence, Tuple

import numpy as np

from audio_reference import dc_blocker, design_fir, fir_causal, load_config, load_wav
from pl_feature_stream import aggregate_feature_arrays


MODEL_VERSION = "pynq-pl-feature-ps-v2.1"
CLASS_NAMES = ("attack", "shield", "none")
DIR_TO_CLASS = {
    "high_voice": "attack",
    "low_voice": "shield",
    "negative": "none",
    "silence": "none",
}
FEATURE_NAMES = (
    "log_rms_8k",
    "log_frame_peak_to_median_power",
    "active_fraction",
    "relative_frame_rms_cv",
    "active_transitions",
    "active_segments",
    "longest_active_run_fraction",
    "spectral_centroid_khz",
    "mag_fraction_80_300",
    "mag_fraction_300_800",
    "mag_fraction_800_2000",
    "mag_fraction_2000_4000",
    "mean_frame_zcr",
)
BANDS_HZ = ((80.0, 300.0), (300.0, 800.0), (800.0, 2000.0), (2000.0, 4000.0))
EPS = 1e-12
FEATURE_INDEX = {name: index for index, name in enumerate(FEATURE_NAMES)}


def _preprocess_8k(path: Path, config_path: Path) -> Tuple[np.ndarray, Dict[str, object]]:
    cfg = load_config(str(config_path))
    samples, rate = load_wav(str(path))
    if rate != int(cfg["fs_input"]):
        raise ValueError("Expected {} Hz, got {} Hz: {}".format(cfg["fs_input"], rate, path))
    filtered = dc_blocker(samples, float(cfg["dc_block_a"]))
    coeff = design_fir(
        float(cfg["fir_fc_hz"]),
        int(cfg["fs_input"]),
        int(cfg["fir_taps"]),
        str(cfg["fir_window"]),
        float(cfg["fir_stop_hz"]),
        float(cfg["fir_stop_db"]),
    )
    filtered = fir_causal(filtered, coeff)
    decimation = int(cfg["fs_input"]) // int(cfg["fs_processed"])
    return filtered[::decimation], cfg


def extract_pl_ps_features(path: Path, config_path: Path) -> np.ndarray:
    """Return PS aggregate features derived only from PL-streamable records."""
    x, cfg = _preprocess_8k(path, config_path)
    frame_size = int(cfg["win"])
    stride = int(cfg["feature_stride"])
    sample_rate = int(cfg["fs_processed"])
    if x.size < frame_size:
        raise ValueError("Recording is too short for one PL frame: {}".format(path))

    frames = np.lib.stride_tricks.sliding_window_view(x, frame_size)[::stride].copy()
    frames -= np.mean(frames, axis=1, keepdims=True)
    power = np.mean(frames * frames, axis=1)
    zcr = np.mean(frames[:, 1:] * frames[:, :-1] < 0.0, axis=1)

    window = np.hamming(frame_size)
    magnitude = np.abs(np.fft.rfft(frames * window, axis=1))
    frequencies = np.fft.rfftfreq(frame_size, d=1.0 / sample_rate)
    total_by_frame = np.sum(magnitude, axis=1)
    weighted_bin = np.sum(magnitude * np.arange(magnitude.shape[1])[np.newaxis, :], axis=1)
    band_columns = []
    for low, high in BANDS_HZ:
        mask = (frequencies >= low) & (frequencies < high)
        band_columns.append(np.sum(magnitude[:, mask], axis=1))

    return aggregate_feature_arrays(
        power, zcr, np.column_stack(band_columns), total_by_frame, weighted_bin,
        sample_rate=sample_rate, frame_size=frame_size,
    )


def predict_feature_vector(model_path: Path, feature: Sequence[float]) -> Dict[str, object]:
    """Classify one already-aggregated PL feature vector."""
    model = load_model(model_path)
    feature = np.asarray(feature, dtype=np.float64)
    if feature.shape != (len(FEATURE_NAMES),) or not np.all(np.isfinite(feature)):
        raise ValueError("invalid PL aggregate feature vector")
    distances = _distances(feature, model["scale"], model["centers"])
    command, command_distance = min(
        ((name, distances[name]) for name in ("attack", "shield")), key=lambda item: item[1]
    )
    ratio = command_distance / (distances["none"] + EPS)
    temporal_guard = _passes_temporal_guard(feature, command, model["guards"])
    return {
        "label": command if temporal_guard and ratio <= model["gate"] else "none",
        "candidate": command, "ratio": float(ratio), "gate_ratio": float(model["gate"]),
        "temporal_guard": temporal_guard, "temporal_guards": model["guards"],
        "distances": distances,
    }


def predict_pl_payload(model_path: Path, payload: object) -> Dict[str, object]:
    """Decode one AXI-DMA batch and classify it, failing closed on bad records."""
    from pl_feature_stream import aggregate_records, parse_feature_records

    try:
        records = parse_feature_records(payload)
        result = predict_feature_vector(model_path, aggregate_records(records))
        result["record_count"] = len(records)
        result["pl_error"] = None
        return result
    except (TypeError, ValueError) as exc:
        return {
            "label": "none", "candidate": "none", "ratio": float("inf"),
            "gate_ratio": None, "temporal_guard": False, "distances": {},
            "record_count": 0, "pl_error": str(exc),
        }


def _fit(features: np.ndarray, labels: np.ndarray) -> Tuple[np.ndarray, Dict[str, np.ndarray]]:
    scale = np.std(features, axis=0)
    scale = np.where(scale < 1e-8, 1.0, scale)
    centers = {name: np.mean(features[labels == name], axis=0) for name in CLASS_NAMES}
    return scale, centers


def _distances(feature: np.ndarray, scale: np.ndarray, centers: Dict[str, np.ndarray]) -> Dict[str, float]:
    return {
        name: float(np.sqrt(np.mean(((feature - centers[name]) / scale) ** 2)))
        for name in CLASS_NAMES
    }


def _fit_temporal_guards(features: np.ndarray, labels: np.ndarray) -> Dict[str, float]:
    """Fit conservative command-shape limits using training commands only."""
    shield = features[labels == "shield"]
    return {
        # One extra segment tolerates a brief threshold crossing inside a
        # sustained command while still rejecting phrase-like speech.
        "shield_max_segments": float(
            np.max(shield[:, FEATURE_INDEX["active_segments"]]) + 1.0
        ),
        "shield_min_longest_run": float(
            0.90 * np.min(shield[:, FEATURE_INDEX["longest_active_run_fraction"]])
        ),
    }


def _passes_temporal_guard(
    feature: np.ndarray, command: str, guards: Dict[str, float]
) -> bool:
    if command != "shield":
        return True
    return bool(
        feature[FEATURE_INDEX["active_segments"]] <= guards["shield_max_segments"]
        and feature[FEATURE_INDEX["longest_active_run_fraction"]]
        >= guards["shield_min_longest_run"]
    )


def _choose_gate(features: np.ndarray, labels: np.ndarray) -> Tuple[float, List[Dict[str, object]]]:
    rows: List[Dict[str, object]] = []
    for index in range(len(features)):
        keep = np.arange(len(features)) != index
        scale, centers = _fit(features[keep], labels[keep])
        guards = _fit_temporal_guards(features[keep], labels[keep])
        distances = _distances(features[index], scale, centers)
        command, command_distance = min(
            ((name, distances[name]) for name in ("attack", "shield")), key=lambda item: item[1]
        )
        ratio = command_distance / (distances["none"] + EPS)
        rows.append(
            {
                "actual": str(labels[index]),
                "command": command,
                "ratio": float(ratio),
                "temporal_guard": _passes_temporal_guard(features[index], command, guards),
            }
        )

    ratios = np.asarray([float(row["ratio"]) for row in rows])
    candidates = np.unique(np.r_[0.01, np.linspace(0.02, 1.5, 300), ratios])
    ranked = []
    for threshold in candidates:
        false_actions = sum(
            row["actual"] == "none"
            and row["temporal_guard"]
            and row["ratio"] <= threshold
            for row in rows
        )
        command_correct = sum(
            row["actual"] in ("attack", "shield")
            and row["command"] == row["actual"]
            and row["temporal_guard"]
            and row["ratio"] <= threshold
            for row in rows
        )
        total_correct = sum(
            (
                row["actual"] == "none"
                and (not row["temporal_guard"] or row["ratio"] > threshold)
            )
            or (
                row["actual"] in ("attack", "shield")
                and row["command"] == row["actual"]
                and row["temporal_guard"]
                and row["ratio"] <= threshold
            )
            for row in rows
        )
        ranked.append((false_actions, -command_correct, -total_correct, float(threshold)))
    return min(ranked)[3], rows


def _collect_training(root: Path, subject: str, config_path: Path) -> Tuple[np.ndarray, np.ndarray, List[Path]]:
    subject_root = root / "data" / "raw" / subject
    features: List[np.ndarray] = []
    labels: List[str] = []
    paths: List[Path] = []
    for directory, label in DIR_TO_CLASS.items():
        for path in sorted((subject_root / directory).glob("*.wav")):
            features.append(extract_pl_ps_features(path, config_path))
            labels.append(label)
            paths.append(path)
    if not paths:
        raise FileNotFoundError("No WAV files under {}".format(subject_root))
    return np.vstack(features), np.asarray(labels), paths


def train(root: Path, subject: str, config_path: Path, model_path: Path, report_path: Path) -> Dict[str, object]:
    features, labels, paths = _collect_training(root, subject, config_path)
    if set(CLASS_NAMES) - set(labels):
        raise ValueError("Each class requires at least one training WAV")
    gate, loo_rows = _choose_gate(features, labels)
    scale, centers = _fit(features, labels)
    guards = _fit_temporal_guards(features, labels)

    model_path.parent.mkdir(parents=True, exist_ok=True)
    np.savez_compressed(
        str(model_path),
        model_version=np.asarray(MODEL_VERSION),
        subject=np.asarray(subject),
        sample_rate=np.asarray(48000, dtype=np.int32),
        feature_names=np.asarray(FEATURE_NAMES),
        feature_scale=scale,
        attack_center=centers["attack"],
        shield_center=centers["shield"],
        none_center=centers["none"],
        gate_ratio=np.asarray(gate, dtype=np.float64),
        shield_max_segments=np.asarray(guards["shield_max_segments"], dtype=np.float64),
        shield_min_longest_run=np.asarray(guards["shield_min_longest_run"], dtype=np.float64),
        class_names=np.asarray(CLASS_NAMES),
    )

    predictions = []
    for path, row in zip(paths, loo_rows):
        predicted = (
            row["command"] if row["temporal_guard"] and row["ratio"] <= gate else "none"
        )
        predictions.append(
            {
                "file": str(path.relative_to(root)),
                "actual": row["actual"],
                "predicted": predicted,
                "ratio": row["ratio"],
                "temporal_guard": row["temporal_guard"],
                "correct": predicted == row["actual"],
            }
        )
    none_rows = [row for row in predictions if row["actual"] == "none"]
    command_rows = [row for row in predictions if row["actual"] != "none"]
    report = {
        "model_version": MODEL_VERSION,
        "subject": subject,
        "model": str(model_path.relative_to(root)),
        "feature_contract": list(FEATURE_NAMES),
        "files": len(predictions),
        "class_counts": {name: int(np.count_nonzero(labels == name)) for name in CLASS_NAMES},
        "gate_ratio": float(gate),
        "temporal_guards": guards,
        "loo_correct": sum(row["correct"] for row in predictions),
        "loo_accuracy": sum(row["correct"] for row in predictions) / float(len(predictions)),
        "loo_false_actions": sum(row["predicted"] != "none" for row in none_rows),
        "loo_command_correct": sum(row["correct"] for row in command_rows),
        "loo_command_total": len(command_rows),
        "predictions": predictions,
    }
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return report


def load_model(path: Path) -> Dict[str, object]:
    with np.load(str(path), allow_pickle=False) as data:
        version = str(data["model_version"].item())
        if version != MODEL_VERSION:
            raise ValueError("Unsupported model version {}".format(version))
        return {
            "version": version,
            "scale": data["feature_scale"].astype(np.float64),
            "centers": {name: data[name + "_center"].astype(np.float64) for name in CLASS_NAMES},
            "gate": float(data["gate_ratio"].item()),
            "guards": {
                "shield_max_segments": float(data["shield_max_segments"].item()),
                "shield_min_longest_run": float(data["shield_min_longest_run"].item()),
            },
        }


def predict(model_path: Path, wav_path: Path, config_path: Path) -> Dict[str, object]:
    feature = extract_pl_ps_features(wav_path, config_path)
    return predict_feature_vector(model_path, feature)


def _expected_validation(path: Path) -> str:
    stem = path.stem.lower()
    if stem.startswith("verify_attack_"):
        return "attack"
    if stem.startswith("verify_shield_"):
        return "shield"
    if stem.startswith("verify_speech_") or stem.startswith("verify_silence_"):
        return "none"
    raise ValueError("Cannot infer validation label from {}".format(path.name))


def validate(model_path: Path, validation_dir: Path, config_path: Path, report_path: Path) -> Dict[str, object]:
    rows = []
    for path in sorted(validation_dir.glob("verify_*.wav")):
        expected = _expected_validation(path)
        result = predict(model_path, path, config_path)
        rows.append(
            {
                "file": path.name,
                "expected": expected,
                "predicted": result["label"],
                "candidate": result["candidate"],
                "ratio": result["ratio"],
                "gate_ratio": result["gate_ratio"],
                "temporal_guard": result["temporal_guard"],
                "distances": result["distances"],
                "correct": result["label"] == expected,
            }
        )
    if not rows:
        raise FileNotFoundError("No verify_*.wav files under {}".format(validation_dir))
    none_rows = [row for row in rows if row["expected"] == "none"]
    command_rows = [row for row in rows if row["expected"] != "none"]
    report = {
        "model_version": MODEL_VERSION,
        "model": str(model_path),
        "validation_dir": str(validation_dir),
        "files": len(rows),
        "correct": sum(row["correct"] for row in rows),
        "accuracy": sum(row["correct"] for row in rows) / float(len(rows)),
        "false_actions": sum(row["predicted"] != "none" for row in none_rows),
        "command_correct": sum(row["correct"] for row in command_rows),
        "command_total": len(command_rows),
        "rows": rows,
    }
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return report


def _wav_metadata(path: Path) -> Dict[str, object]:
    with wave.open(str(path), "rb") as handle:
        return {
            "sample_rate": handle.getframerate(),
            "channels": handle.getnchannels(),
            "sample_width_bytes": handle.getsampwidth(),
            "frames": handle.getnframes(),
            "duration_seconds": handle.getnframes() / float(handle.getframerate()),
        }


def freeze_manifest(root: Path, subject: str, validation_dir: Path, output: Path) -> int:
    rows = []
    train_root = root / "data" / "raw" / subject
    for directory, label in DIR_TO_CLASS.items():
        for path in sorted((train_root / directory).glob("*.wav")):
            rows.append(("train", label, path))
    for path in sorted(validation_dir.glob("verify_*.wav")):
        rows.append(("validation", _expected_validation(path), path))

    output.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = (
        "dataset",
        "label",
        "relative_path",
        "sha256",
        "size_bytes",
        "sample_rate",
        "channels",
        "sample_width_bytes",
        "frames",
        "duration_seconds",
    )
    with output.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for dataset, label, path in rows:
            metadata = _wav_metadata(path)
            writer.writerow(
                {
                    "dataset": dataset,
                    "label": label,
                    "relative_path": str(path.relative_to(root)).replace("\\", "/"),
                    "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
                    "size_bytes": path.stat().st_size,
                    **metadata,
                }
            )
    return len(rows)


def verify_manifest(root: Path, manifest: Path) -> Tuple[int, List[str]]:
    """Verify the already-frozen WAV list without rewriting its expected hashes."""
    errors: List[str] = []
    with manifest.open("r", newline="", encoding="utf-8-sig") as handle:
        rows = list(csv.DictReader(handle))
    for row in rows:
        relative = row["relative_path"]
        path = root / Path(relative)
        if not path.is_file():
            errors.append("missing: {}".format(relative))
            continue
        actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual_hash != row["sha256"]:
            errors.append("sha256 mismatch: {}".format(relative))
        if path.stat().st_size != int(row["size_bytes"]):
            errors.append("size mismatch: {}".format(relative))
    return len(rows), errors


def _brief(report: Dict[str, object]) -> Dict[str, object]:
    return {key: value for key, value in report.items() if key not in ("rows", "predictions")}


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--config", type=Path, default=None)
    commands = parser.add_subparsers(dest="command", required=True)

    train_parser = commands.add_parser("train")
    train_parser.add_argument("--subject", default="subject02")
    train_parser.add_argument("--model", required=True, type=Path)
    train_parser.add_argument("--report", required=True, type=Path)

    validate_parser = commands.add_parser("validate")
    validate_parser.add_argument("--model", required=True, type=Path)
    validate_parser.add_argument("--validation-dir", required=True, type=Path)
    validate_parser.add_argument("--report", required=True, type=Path)

    predict_parser = commands.add_parser("predict")
    predict_parser.add_argument("--model", required=True, type=Path)
    predict_parser.add_argument("--wav", required=True, type=Path)

    freeze_parser = commands.add_parser("freeze")
    freeze_parser.add_argument("--subject", default="subject02")
    freeze_parser.add_argument("--validation-dir", required=True, type=Path)
    freeze_parser.add_argument("--output", required=True, type=Path)

    args = parser.parse_args(argv)
    root = args.root.resolve()
    config_path = (args.config or (root / "config" / "audio_config.json")).resolve()

    if args.command == "train":
        report = train(root, args.subject, config_path, args.model.resolve(), args.report.resolve())
        print(json.dumps(_brief(report), ensure_ascii=False, indent=2))
        return 0
    if args.command == "validate":
        report = validate(args.model.resolve(), args.validation_dir.resolve(), config_path, args.report.resolve())
        print(json.dumps(_brief(report), ensure_ascii=False, indent=2))
        return 0 if report["accuracy"] >= 0.90 and report["false_actions"] == 0 else 1
    if args.command == "predict":
        print(json.dumps(predict(args.model.resolve(), args.wav.resolve(), config_path), ensure_ascii=False, indent=2))
        return 0
    count = freeze_manifest(root, args.subject, args.validation_dir.resolve(), args.output.resolve())
    print("Wrote {} frozen WAV records to {}".format(count, args.output.resolve()))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
