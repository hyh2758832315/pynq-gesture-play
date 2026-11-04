import argparse
import csv
import hashlib
import io
import json
import time
from email.parser import BytesHeaderParser
from http.client import HTTPConnection
from pathlib import Path
from urllib.parse import urlsplit

import numpy as np


def summarize(samples: list[dict[str, float | int | str]]) -> dict[str, float | int | None]:
    timestamps = [float(sample["timestamp"]) for sample in samples]
    intervals = np.diff(timestamps)
    return {
        "frames": len(samples),
        "fps": round((len(samples) - 1) / (timestamps[-1] - timestamps[0]), 2) if len(samples) > 1 else None,
        "p50_ms": round(float(np.percentile(intervals, 50)) * 1000, 1) if len(intervals) else None,
        "p95_ms": round(float(np.percentile(intervals, 95)) * 1000, 1) if len(intervals) else None,
        "max_ms": round(float(max(intervals)) * 1000, 1) if len(intervals) else None,
        "black_frames": sum(float(sample["std"]) < 2 for sample in samples),
        "unique_frames": len({sample["sha256"] for sample in samples}),
    }


def measure(url: str, seconds: float, clients: int, output: Path) -> None:
    from PIL import Image

    address = urlsplit(url)
    if address.scheme != "http" or not address.hostname:
        raise ValueError("Expected an HTTP MJPEG URL")
    with output.open("w", newline="", encoding="ascii") as result:
        writer = csv.DictWriter(result, fieldnames=("client", "frame", "timestamp", "bytes", "width", "height", "std", "sha256"))
        writer.writeheader()
        for client in range(clients):
            connection = HTTPConnection(address.hostname, address.port or 80, timeout=12)
            response = None
            samples: list[dict[str, float | int | str]] = []
            try:
                connection.request("GET", address.path or "/")
                response = connection.getresponse()
                if response.status != 200:
                    raise RuntimeError(f"MJPEG HTTP status {response.status}")
                deadline = time.monotonic() + seconds
                while time.monotonic() < deadline:
                    if response.readline() != b"--frame\r\n":
                        raise RuntimeError("Missing MJPEG frame boundary")
                    header_lines = []
                    while (line := response.readline()) != b"\r\n":
                        if not line:
                            raise EOFError("Truncated MJPEG frame headers")
                        header_lines.append(line)
                    headers = BytesHeaderParser().parsebytes(b"".join(header_lines) + b"\r\n")
                    length = int(headers["Content-Length"])
                    data = response.read(length)
                    if len(data) != length or response.readline() != b"\r\n":
                        raise EOFError("Truncated MJPEG frame body")
                    image = np.asarray(Image.open(io.BytesIO(data)).convert("RGB"))
                    sample = {
                        "client": client,
                        "frame": len(samples),
                        "timestamp": time.monotonic(),
                        "bytes": length,
                        "width": image.shape[1],
                        "height": image.shape[0],
                        "std": round(float(image.std()), 4),
                        "sha256": hashlib.sha256(data).hexdigest(),
                    }
                    writer.writerow(sample)
                    samples.append(sample)
            finally:
                if response is not None:
                    response.close()
                connection.close()
            result.flush()
            print(json.dumps({"client": client, **summarize(samples)}, sort_keys=True), flush=True)


def main() -> None:
    parser = argparse.ArgumentParser(description="Measure decoded MJPEG frames on the PC")
    parser.add_argument("url")
    parser.add_argument("output", type=Path)
    parser.add_argument("--seconds", type=float, default=8)
    parser.add_argument("--clients", type=int, default=2)
    args = parser.parse_args()
    if args.seconds <= 0 or args.clients <= 0:
        parser.error("--seconds and --clients must be positive")
    measure(args.url, args.seconds, args.clients, args.output)


if __name__ == "__main__":
    main()