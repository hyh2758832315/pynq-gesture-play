"""Editable two-video defaults and reuse of fully verified Studio artifacts."""
from pathlib import Path
from pynq_multimodal_game.studio.default_content import initial_video_sources,default_video_paths
from pynq_multimodal_game.studio.content_pipeline import load_content,ContentItem
from pynq_multimodal_game.video_codec import S2V1Reader,encode_rgb_frames
from tests.test_studio_content_flow import FakeDevice


class Settings:
    def __init__(self):self.data={}
    def value(self,key,default=None,**kw):return self.data.get(key,default)
    def setValue(self,key,value):self.data[key]=value


def test_two_defaults_appear_once_and_user_removal_survives_reopening():
    s=Settings();expected=[str(p) for p in default_video_paths()]
    assert initial_video_sources(s)==expected
    s.setValue('content/videos',[expected[1]])
    assert initial_video_sources(s)==[expected[1]]
    s.setValue('content/videos',[])
    assert initial_video_sources(s)==[]


def test_cached_video_avoids_reencoding_and_identical_board_item_avoids_upload(tmp_path,monkeypatch):
    source=tmp_path/'source.s2v'
    encode_rgb_frames([bytes((30,40,50))*57600],source)
    items=[ContentItem('video',source,'Clip')];device=FakeDevice()
    first=load_content(items,device,tmp_path/'first')
    assert first['items'][0]['video_validation']=='full-decode' and len(device.installs)==1
    def no_decode(*args,**kw):raise AssertionError('Unchanged verified content must use cache')
    monkeypatch.setattr(S2V1Reader,'iter_frames',no_decode)
    second=load_content(items,device,tmp_path/'second')
    assert second['status']=='complete' and len(device.installs)==1
    assert second['items'][0]['video_validation']=='sha-verified-cache'
    assert second['items'][0]['installation']=='already_present'


def test_damaged_cache_is_not_accepted_as_validated_content(tmp_path):
    source=tmp_path/'source.s2v';encode_rgb_frames([bytes((10,20,30))*57600],source)
    item=[ContentItem('video',source,'Clip')]
    load_content(item,FakeDevice(),tmp_path/'first',prepare_only=True)
    cache=next((tmp_path/'.video-cache').glob('*/video.s2v'))
    cache.write_bytes(b'damaged')
    result=load_content(item,FakeDevice(),tmp_path/'second',prepare_only=True)
    assert result['items'][0]['video_validation']=='full-decode'
