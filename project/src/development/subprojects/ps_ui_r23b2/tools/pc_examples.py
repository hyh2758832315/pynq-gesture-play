"""Soundless, asserted PC walkthroughs shared by the four Studio projects."""
import json


def example(item_id,root):
    def event(tick,x,y,pose):
        return dict(tick=tick,kind='gesture',event_id=f'step-{tick}',x=x,y=y,gesture=pose)
    def check(tick,field,op,value):
        return dict(tick=tick,field=field,operator=op,expected=value)
    if item_id=='game2':
        cases=[json.loads(p.read_text(encoding='utf-8')) for p in (root/'games/game2/tests/replays').glob('*.json')]
        value=next(c for c in cases if c['test_id']=='rps-win')
        value.update(test_id='pc-example-game2',name='PC示例：三轮猜拳')
        return value
    names={'game1':'移动、握拳跳跃与松开','game3':'选角、移动与跳跃','game4':'指向转弯、握拳加速与松开'}
    value=dict(schema_version=2,test_id='pc-example-'+item_id,name='PC示例：'+names[item_id],seed=17,
               max_ticks=180,events=[],assertions=[])
    if item_id=='game1':
        value['events']=[event(0,319,90,'paper'),event(60,319,90,'fist'),event(90,160,0,'paper'),
                         event(120,0,90,'paper'),event(150,160,179,'paper')]
        value['assertions']=[check(59,'values.world_x','gt',0),check(61,'values.z','gt',0),
            check(180,'values.attacks_fired','eq',0),check(180,'values.shield_active','eq',False)]
    elif item_id=='game3':
        value['max_ticks']=149
        value['events']=[event(0,319,90,'fist'),event(1,160,90,'paper'),event(30,319,90,'paper'),
                         event(60,319,90,'fist'),event(100,160,90,'paper'),event(130,0,90,'paper')]
        value['assertions']=[check(0,'values.character','eq','female'),check(59,'values.world_x','gt',60),
                            check(61,'values.world_y','lt',124),check(149,'values.note_hits','eq',0)]
    else:
        value['max_ticks']=300
        value['events']=[event(0,310,80,'fist'),event(151,310,80,'paper'),event(180,310,175,'paper'),
                         event(240,0,175,'fist'),event(299,160,90,'paper')]
        value['assertions']=[check(119,'values.moves','eq',0),check(149,'values.moves','eq',6),
                            check(155,'values.boosted','eq',False),check(200,'values.moves','gt',6)]
    return value
