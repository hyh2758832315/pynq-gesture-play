"""Reproduce moving OSD + temporary idle gameplay without CPU contention.

Run: PYTHONPATH=subprojects/ps_ui_r23b2/python python -m pytest -q this_file
Output: assertions only; does not access a board, camera, MMIO or serial port.
Next: correlate operator observations before changing gameplay validity rules.
"""
import importlib.util
from pathlib import Path
import sys

from pynq_multimodal_game.button_osd import ObservationHub
from pynq_multimodal_game.controls import Direction

ROOT=Path(__file__).resolve().parents[2]


def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);sys.modules[name]=module
    spec.loader.exec_module(module)
    return module


def test_roi_edge_rejection_alone_reproduces_both_games_stop_then_self_recover():
    # Preserve the pre-R40 diagnosis against its immutable provider version.
    GameVisionInputProvider=load('pynq_multimodal_game.r39_edge_input',
        ROOT/'build/ps-ui-r39-button-controls-20261026-board-candidate-r26/python/pynq_multimodal_game/vision_input.py').GameVisionInputProvider
    virtual=load('diagnostic_virtual_control',ROOT/'handoffs/gesture_vision_v61/runtime/gesture_control.py').GestureControl()
    first=load('diagnostic_game1',ROOT/'subprojects/ps_ui_r23b2/game_overrides/game1_input_adapter.py').Game1InputAdapter()
    third=load('diagnostic_game3',ROOT/'subprojects/ps_ui_r23b2/game_overrides/game3_input_adapter.py')
    now=[100.];provider=GameVisionInputProvider(clock=lambda:now[0]);hub=ObservationHub()
    directions=[]
    for frame,edge in enumerate((False,True,True,False),1):
        now[0]=100+frame*.1
        result=dict(centroid=(470+frame*4,180),bbox=(420,90,530,280),
                    stable='5',rps='PAPER',code='5',touches_roi=edge,error=None)
        control=virtual.update(result,frame,now[0])
        u,v=(result['centroid'][0]-319.5)/320.,(result['centroid'][1]-179.5)/180.
        provider.publish(dict(run_id='same-camera',frame=frame,server_age_ms=20,
            control=control,stable='5',rps='PAPER',
            ui_pointer=dict(schema='menu-pointer-v1',u=u,v=v)),config_epoch='same-config')
        hub.publish(result,run_id='same-camera',config_epoch='same-config',frame_id=frame,
                    observed_ns=int(now[0]*1e9))
        one,_=provider.sample_for_game('game1',tick_id=frame)
        three,_=provider.sample_for_game('game3',tick_id=frame)
        directions.append((first.adapt(one).direction,third.adapt(three).direction))
        assert hub.hand.valid and hub.hand.frame==frame  # marker remains live
        assert one.hand_valid is (not edge)
        assert control['reason']==('FRAME_EDGE' if edge else 'OK')
    assert directions==[(Direction.RIGHT,1),(Direction.IDLE,0),
                        (Direction.IDLE,0),(Direction.RIGHT,1)]
