"""Outcome hierarchy, recorded scores and unchanged frozen-GPU budgets."""
import pytest
from pynq_multimodal_game.pause_menu import PauseRenderer,RESULT_TARGETS
from pynq_multimodal_game.shell_pages import pause_page
from pynq_multimodal_game.gpu_abi import pack_asset_bundle_packet,COMMAND_CAPACITY


@pytest.mark.parametrize('outcome,color',[('WON',3),('LOST',6),('DRAW',4)])
def test_result_heading_is_large_semantic_color_and_score_is_visible(outcome,color):
    a=pause_page(outcome,RESULT_TARGETS,None,0)
    b=pause_page(outcome,RESULT_TARGETS,None,260)
    heading=b[13*320:38*320]
    assert heading.count(color)>500
    assert a[52*320:62*320]!=b[52*320:62*320]
    assert all(a[y*320:(y+1)*320]==b[y*320:(y+1)*320] for y in range(67,121))
    renderer=PauseRenderer(outcome=outcome,score=260)
    frames=[renderer.compile(i,5,hovered,progress=.7) for i,hovered in enumerate((None,'restart','main-menu'))]
    assert len({pack_asset_bundle_packet(f.assets,generation=5) for f in frames})==1
    assert len(pack_asset_bundle_packet(frames[0].assets,generation=5))<=32880
    assert all(f.header.command_count<=COMMAND_CAPACITY for f in frames)


@pytest.mark.parametrize('score',[-1,True,2.5])
def test_invalid_result_score_rejected(score):
    with pytest.raises(ValueError):PauseRenderer(outcome='WON',score=score)
