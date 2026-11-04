from __future__ import annotations

from copy import deepcopy
import math


def validate_voice_monitor(snapshot: object) -> dict:
    if not isinstance(snapshot, dict) or type(snapshot) is not dict or snapshot.get("profile") != "C6I_VISION_VOICE_S3":
        raise ValueError("Require explicit fusion voice profile")
    if type(snapshot.get("build_id")) is not int or snapshot["build_id"] != 0xC0060900:
        raise ValueError("Fusion voice BUILD_ID mismatch")
    voice = snapshot.get("voice")
    if type(voice) is not dict or voice.get("schema") != "voice-monitor-v1":
        raise ValueError("Require voice-monitor-v1 observation")
    if voice.get("runtime_registered") is not False or voice.get("board_pending") is not True or voice.get("release_ready") is not False:
        raise ValueError("Fusion candidate permissions changed")
    if voice.get("state") not in ("IDLE", "STARTING", "READY", "RUNNING", "STOPPED", "FAULT", "RETAINED"):
        raise ValueError("Invalid voice monitor state")
    for key in ("source_age_verified", "board_validated"):
        if type(voice.get(key)) is not bool:
            raise ValueError("Missing voice evidence boundary: " + key)
    packets = voice.get("packets")
    if type(packets) is not int or not 0 <= packets <= 900 or voice.get("samples") != packets * 960:
        raise ValueError("Invalid voice packet/sample count")
    if type(voice.get("samples")) is not int or voice.get("nominal_sample_hz") != 48000:
        raise ValueError("Invalid nominal voice PCM contract")
    if voice.get("first_error") is not None and type(voice["first_error"]) is not str:
        raise ValueError("Invalid voice error receipt")
    cpu = voice.get("cpu")
    if type(cpu) is not dict or len(cpu) > 16:
        raise ValueError("Invalid voice CPU receipt")
    for key in ("submitted", "received"):
        if key in cpu and (type(cpu[key]) is not int or not 0 <= cpu[key] <= 900):
            raise ValueError("Invalid CPU count")
    if cpu.get("received", 0) > cpu.get("submitted", 0):
        raise ValueError("CPU results exceed submissions")
    pcm = voice.get("pcm")
    if pcm is not None:
        if type(pcm) is not dict or pcm.get("sample_hz") != 48000 or pcm.get("stride") != 4:
            raise ValueError("Invalid voice PCM sampling contract")
        if type(pcm.get("packet_index")) is not int or not 0 <= pcm["packet_index"] < packets:
            raise ValueError("Unsubmitted PCM observation")
        values = pcm.get("samples")
        if type(values) is not list or len(values) != 240 or any(type(value) is not int or not -32768 <= value <= 32767 for value in values):
            raise ValueError("Require bounded signed16 voice waveform")
        if type(pcm.get("historical")) is not bool:
            raise ValueError("Missing PCM historical identity")
        for key in ("producer_run", "audio_epoch"):
            if type(voice.get(key)) is not str or not 0 < len(voice[key]) <= 256:
                raise ValueError("Missing PCM source identity")
    observation = voice.get("recognition")
    if observation is not None:
        if type(observation) is not dict or observation.get("schema") != "voice-observation-v1":
            raise ValueError("Invalid recognition schema")
        for key in ("producer_run", "audio_epoch"):
            if observation.get(key) != voice.get(key):
                raise ValueError("Recognition source identity mismatch")
        index = observation.get("packet_index")
        if type(index) is not int or not 0 <= index < packets:
            raise ValueError("Unsubmitted recognition observation")
        for key in ("decision_ns",):
            if type(observation.get(key)) is not int or not 0 <= observation[key] <= 2**63 - 1:
                raise ValueError("Invalid recognition decision clock")
        elapsed = observation.get("processing_seconds")
        if type(elapsed) not in (int, float) or not math.isfinite(elapsed) or elapsed < 0:
            raise ValueError("Invalid recognition processing time")
        events = observation.get("events")
        if type(events) is not list or len(events) > 64:
            raise ValueError("Invalid recognition event capacity")
        for event in events:
            if type(event) is not dict or event.get("kind") not in ("HIGH_ONSET", "LOW_SEGMENT_ON", "LOW_SEGMENT_OFF"):
                raise ValueError("Invalid recognition event")
            if type(event.get("sequence")) is not int or event["sequence"] < 1:
                raise ValueError("Invalid recognition sequence")
    age = voice.get("decision_age_ns")
    if age is not None and (type(age) is not int or age < 0):
        raise ValueError("Invalid board decision age")
    return deepcopy(voice)