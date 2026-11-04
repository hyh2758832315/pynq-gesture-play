"""Render the actual HDMI command stream without board access.

Run: PYTHONPATH=subprojects/ps_ui_r23b2/python .venv/Scripts/python.exe
     subprojects/ps_ui_r23b2/tools/preview_shell_pages.py
Outputs: build/r45-shell-preview/*.png and budget.json.
Next: inspect the contact sheet and run test_shell_design.py before Studio loading.
"""
import json
import argparse
from pathlib import Path
from PySide6.QtGui import QImage,QPainter
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.creative_pages import CanvasPage,PixelPageRenderer,robot_frame,stamp,album_frame
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.pause_menu import PauseRenderer
from pynq_multimodal_game.scene_compiler import CommandRenderer
from pynq_multimodal_game.gpu_abi import pack_assets,pack_asset_bundle_packet
from pynq_multimodal_game.shell_pages import content_loading,home_options
from pynq_multimodal_game.startup_ui import StartupRenderer,StartupSnapshot,CheckState
from types import SimpleNamespace

ROOT=Path(__file__).resolve().parents[3]

def frames():
    startup=StartupRenderer()
    yield 'startup',startup.compile(StartupSnapshot(),frame_id=1,generation=1,elapsed_seconds=3)
    yield 'startup-error',startup.compile(StartupSnapshot((CheckState.FAIL,)*4,'error'),frame_id=2,generation=1)
    shell=C6IShellRuntimeBackend(object(),menu_fps=0)
    shell._game_ids=('game1','game2','game3','game4')
    shell._game_entries={key:SimpleNamespace(manifest=SimpleNamespace(display_name=name))
        for key,name in zip(shell._game_ids,('SKY RUN','RPS','HAND QUEST','SNAKE DUEL'))}
    for page in (MenuPage.HOME,MenuPage.GAMES):
        shell._select_page_locked(page)
        shell._input._hovered_id=shell._targets[1].item_id
        yield page.value,shell._compile_menu_frame_locked()
    for count in (0,4,5):
        shell._video_entries={str(i):SimpleNamespace(manifest=SimpleNamespace(item_id=str(i),
            display_name=f'STUDIO TEST {i+1}')) for i in range(count)}
        shell._select_page_locked(MenuPage.VIDEOS)
        yield f'videos-{count}',shell._compile_menu_frame_locked()
    renderer=PixelPageRenderer()
    yield 'game-loading',renderer.compile(content_loading('SKY RUN'),1,1,show_return=False)
    canvas=CanvasPage()
    yield 'canvas-empty',renderer.compile_canvas(canvas,1,1)
    for i,shape in enumerate(('triangle','square','circle','star')):
        stamp(canvas.pixels,shape,30,50+i*48,70+i*18,3+i,stride=256)
    canvas.revision=1;canvas.shape='star';canvas.pointer=(160,80)
    yield 'canvas',renderer.compile_canvas(canvas,1,1)
    yield 'album-empty',renderer.compile(album_frame(None),1,1)
    yield 'album-saved',renderer.compile(album_frame(bytes(canvas.pixels)),1,1)
    canvas.dialog=True;canvas.dialog_target='clear'
    yield 'canvas-return',renderer.compile(canvas.render(),1,1)
    yield 'home-options',renderer.compile(home_options('restart',12),1,1)
    geometry=json.loads((Path(__file__).parents[1]/'python/pynq_multimodal_game/data/demo_geometry.json').read_text())
    for pose in ('demo:6','demo:9','demo:heart'):
        yield pose.replace(':','-'),renderer.compile(robot_frame(pose,'PLAYING',6,geometry),1,1)
    for outcome in (None,'WON','LOST','DRAW'):
        yield 'pause' if outcome is None else outcome.lower(),PauseRenderer(outcome=outcome,score=1250).compile(1,1,'restart',.5)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT/'build/r45-shell-preview')
    out=parser.parse_args().output.resolve();out.mkdir(parents=True,exist_ok=True)
    cpu=CommandRenderer();results=[];images=[]
    for name,frame in frames():
        bundle=pack_assets(frame.assets,generation=1)
        packet=pack_asset_bundle_packet(frame.assets,generation=1)
        rgb=cpu.render(frame)
        image=QImage(rgb,320,180,960,QImage.Format_RGB888).copy()
        image.scaled(1280,720).save(str(out/(name+'.png')))
        images.append(image)
        results.append(dict(page=name,payload_bytes=len(bundle.payload),packet_bytes=len(packet),
                            commands=len(frame.commands),predicted_cycles=frame.header.predicted_cycles))
    sheet=QImage(960,180*((len(images)+2)//3),QImage.Format_RGB888)
    sheet.fill(0xffffff);painter=QPainter(sheet)
    for i,image in enumerate(images):painter.drawImage(i%3*320,i//3*180,image)
    painter.end();sheet.save(str(out/'contact.png'))
    (out/'budget.json').write_text(json.dumps(results,indent=2)+'\n')
    print(json.dumps(dict(pages=len(results),max_payload=max(r['payload_bytes'] for r in results),
        max_commands=max(r['commands'] for r in results),output=str(out))))

if __name__=='__main__':main()
