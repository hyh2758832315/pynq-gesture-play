import ast
from http.client import HTTPConnection
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from threading import Event, Lock, Thread
from types import SimpleNamespace
import json
import sys
import time

import cv2
import numpy as np
import pytest

import single_stage_preview as policy

ROOT = Path(__file__).resolve().parents[1] / 'r8_deployment/c6i-vision-board-test-boarddeps-r8-20261006'


def fixture():
    rng = np.random.default_rng(19)
    raw = rng.integers(0,256,(360,640,3),dtype=np.uint8)
    contour = np.array([[[20,20]],[[120,20]],[[120,120]],[[20,120]]],np.int32)
    result = dict(roi=(50,40,450,340), contour=contour, hull=contour, centroid=(90,110),
                  code='5',stable='5',fingers=5, mask=rng.integers(0,256,(300,400),dtype=np.uint8),
                  debug_images=dict(input=raw, skin=rng.integers(0,2,(300,400),dtype=np.uint8)*255,
                                    contours=[contour], defects=[((20,20),(120,20),(70,60))]))
    control = dict(trajectory=[(100,100),(110,115)],enter=.25,release=.15,smooth_uv=(.2,-.3),
                   direction='UP',reason='TRACKING',action_event_seq=2)
    return result,control


@pytest.mark.parametrize('stage',range(6))
def test_matches_original_tile_without_mutating_input(stage):
    source = ROOT / 'handoffs/gesture_vision_v61/runtime/debug_view.py'
    namespace = dict(cv2=cv2,np=np)
    exec(compile(source.read_text(),str(source),'exec'),namespace)
    result,control = fixture()
    before = result['debug_images']['input'].copy()
    expected = namespace['six_panel'](result,control,17)
    tile = expected[(stage//3)*180:(stage//3+1)*180,(stage%3)*320:(stage%3+1)*320]
    assert np.array_equal(policy.stage_image(result,control,17,stage),tile)
    assert np.array_equal(result['debug_images']['input'],before)


def runtime_fixture():
    path = ROOT / 'board/pynq_z2/scripts/vision_async_runtime.py'
    tree = ast.parse(path.read_text())
    node = next(n for n in tree.body if isinstance(n,ast.ClassDef) and n.name=='BytesPreview')
    namespace = dict(Lock=Lock,Event=Event,Thread=Thread,time=time,json=json,
                     BaseHTTPRequestHandler=BaseHTTPRequestHandler,ThreadingHTTPServer=ThreadingHTTPServer,
                     RUNTIME_DIR=ROOT/'handoffs/gesture_vision_v61/runtime')
    exec(compile(ast.Module(body=[node],type_ignores=[]),str(path),'exec'),namespace)
    return SimpleNamespace(BytesPreview=namespace['BytesPreview'],ProcessPreviewEncoder=object,
                           encode_preview_snapshot=lambda *a: b'legacy')


def get(preview,path):
    connection = HTTPConnection('127.0.0.1',preview.server.server_port,timeout=2)
    try:
        connection.request('GET',path)
        response = connection.getresponse()
        return response.status,dict(response.getheaders()),response.read()
    finally:
        connection.close()


def test_http_demand_identity_switch_health_and_legacy():
    runtime = runtime_fixture()
    policy.install(runtime)
    preview = runtime.BytesPreview('127.0.0.1',0)
    try:
        assert preview.demand()==frozenset()
        assert get(preview,'/debug-stage.jpg?stage=8')[0]==400
        assert get(preview,'/debug-stage.jpg?stage=3')[0]==503
        assert preview.demand()==frozenset({'debug'})
        preview.publish_debug(policy.HEADER.pack(policy.MAGIC,3,77)+b'jpeg')
        status,headers,payload = get(preview,'/debug-stage.jpg?stage=3')
        assert status==200 and payload==b'jpeg'
        assert headers['X-Vision-Frame']=='77' and headers['X-Vision-Stage']=='3'
        assert headers['X-Vision-Run']==preview.preview_run
        assert get(preview,'/debug-stage.jpg?stage=4')[0]==503
        preview.publish_debug(b'legacy-jpeg')
        assert get(preview,'/debug.jpg')[2]==b'legacy-jpeg'
        assert preview.selected_stage==-1
        preview.stage_cache[3]=(b'old',77,time.monotonic()-2)
        assert get(preview,'/debug-stage.jpg?stage=3')[0]==503
        preview.update_health(dict(status='DEGRADED'))
        assert preview.stage_cache=={} and preview.demand()==frozenset()
    finally:
        preview.close()
    assert not preview.thread.is_alive()


def test_single_stage_encode_envelope(monkeypatch):
    result,control = fixture()
    result['_preview_stage']=2
    monkeypatch.setitem(sys.modules,'vision_async_runtime',SimpleNamespace(encode_preview_snapshot=lambda *a:b'legacy'))
    payload = policy.encode_snapshot(SimpleNamespace(result=result,control=control,frame=88),'debug')
    assert policy.HEADER.unpack(payload[:policy.HEADER.size])==(policy.MAGIC,2,88)
    assert cv2.imdecode(np.frombuffer(payload[policy.HEADER.size:],np.uint8),cv2.IMREAD_COLOR).shape==(180,320,3)


def test_spawn_encoder_and_clean_close(monkeypatch):
    from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder, PreviewSnapshot
    monkeypatch.syspath_prepend(str(ROOT/'board/pynq_z2/scripts'))
    result,control = fixture()
    result['_preview_stage']=4
    received = Event()
    payloads = []
    def publish(mode,payload):
        payloads.append(payload)
        received.set()
    encoder = ProcessPreviewEncoder(lambda:frozenset({'debug'}),policy.encode_snapshot,publish,
                                    startup_timeout=30)
    try:
        assert encoder.submit(lambda modes:PreviewSnapshot(42,modes,None,result,control))
        assert received.wait(10), encoder.stats()
        assert policy.HEADER.unpack(payloads[0][:policy.HEADER.size])==(policy.MAGIC,4,42)
        assert encoder.stats()['errors']==0
    finally:
        encoder.close()
    assert encoder.health().status=='CLOSED'
