"""Canvas input/render separation and byte-exact GPU preview coverage."""
from dataclasses import replace
import pytest
from pynq_multimodal_game.creative_pages import CanvasPage,PixelPageRenderer,SHAPES,SIZES,add_album_control
from pynq_multimodal_game.scene_compiler import CommandRenderer
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.gpu_abi import COMMAND_CAPACITY
from subprojects.ps_ui_r23b2.test_creative_pages import shell,offer

def test_moving_preview_never_uploads_the_canvas_again():
    s=shell();s._select_page_locked(MenuPage.CANVAS)
    s._canvas.shape='star';s._canvas.size_index=5
    s._feature_last_submit=-1;s._submit_menu_frame_locked()
    count=len(s._sink.assets)
    for n in range(30):
        s._canvas.pointer=(40+n*5,90)
        s._feature_last_submit=-1;s._submit_menu_frame_locked()
    assert len(s._sink.assets)==count
    offer(s._canvas,100,90,10,'fist',1)
    s._feature_last_submit=-1;s._submit_menu_frame_locked()
    assert len(s._sink.assets)==count+1

def test_unselected_pointer_motion_does_not_submit_scenes():
    s=shell();s._select_page_locked(MenuPage.CANVAS)
    s._feature_last_submit=-1;s._submit_menu_frame_locked()
    count=len(s._sink.scenes)
    for n in range(10):
        s._canvas.pointer=(40+n*5,90)
        s._feature_last_submit=-1;s._submit_menu_frame_locked()
    assert len(s._sink.scenes)==count

@pytest.mark.parametrize('shape',SHAPES)
@pytest.mark.parametrize('size',SIZES)
def test_gpu_preview_matches_raster_reference_including_clipping(shape,size):
    page=CanvasPage();page.shape=shape;page.size_index=SIZES.index(size)
    renderer=PixelPageRenderer();reference=CommandRenderer()
    for point in ((7,26),(12,12),(247,171),(255,90),(256,90),(120,90),None):
        page.pointer=point
        expected=renderer.compile(page.render(),1,3,.5)
        expected=add_album_control(expected)
        actual=renderer.compile_canvas(page,1,3)
        # Use the same return progress in both paths.
        from pynq_multimodal_game.return_button import add_return_progress_to_compiled
        actual=add_return_progress_to_compiled(actual,.5)
        assert len(actual.commands)<=COMMAND_CAPACITY
        assert reference.render_tokens(actual)==reference.render_tokens(expected)

def test_cached_canvas_rebuilds_for_clear_selection_dialog_and_generation():
    page=CanvasPage();r=PixelPageRenderer();reference=CommandRenderer()
    for n in range(6):
        page.shape=SHAPES[n%4];page.size_index=n;page.dialog=(n%2==1)
        page.dialog_target='clear';page.dialog_dwell.update(True,1)
        page.dialog_dwell.update(True,1_000_000_001)
        frame=r.compile_canvas(page,n,n+1)
        expected=r.compile(page.render(),n,n+1,page.back.progress)
        if not page.dialog:expected=add_album_control(expected)
        assert reference.render_tokens(frame)==reference.render_tokens(expected)
        assert frame.header.asset_generation==n+1


@pytest.mark.parametrize('point',[(288,31),(288,66),(288,101),(288,136),(272,167),(304,167)])
def test_sidebar_hover_gpu_commands_match_raster_without_asset_upload(point):
    page=CanvasPage();page.shape='star';page.size_index=5
    r=PixelPageRenderer();reference=CommandRenderer()
    before=r.compile_canvas(page,0,3)
    offer(page,*point,10,'paper',1)
    actual=r.compile_canvas(page,1,3)
    expected=add_album_control(r.compile(page.render(),1,3))
    assert actual.assets is before.assets
    assert reference.render_tokens(actual)==reference.render_tokens(expected)
    assert len(actual.commands)<=COMMAND_CAPACITY
