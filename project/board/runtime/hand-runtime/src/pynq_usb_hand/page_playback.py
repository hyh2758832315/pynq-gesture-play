"""Single serial-owner page arbiter. Called by existing lifecycle loop only."""
import json
import math
import os
from pathlib import Path
import time

DEMO_STATES = tuple('demo:'+str(i) for i in range(10))+('demo:heart',)


class PageHeartbeatExpired(ValueError):
    """A correctly addressed command whose original permission has expired."""


def load_demo_poses(model, directory):
    from orca_core.control.manual_motor import load_motor_pose
    directory=Path(directory)
    default=model.to_joint(load_motor_pose(model.hand,directory/'default.txt'))
    if any(abs(default[k]-model.poses['default'][k])>1e-7 for k in default):
        raise ValueError('Demo default differs from checked startup pose')
    for state in DEMO_STATES:
        name=state.split(':')[1]
        target=model.to_joint(load_motor_pose(model.hand,directory/(name+'.txt')))
        model.to_motor(target)
        model.poses[state]=target


class PageCommandChannel:
    """Identity-bound latest command, parent heartbeat; never an action queue."""
    def __init__(self,directory,session,game_run,clock=time.monotonic):
        self.directory=Path(directory)
        self.session,self.game_run,self.clock=session,game_run,clock
        self.generation=-1
        self.command=None
        self.last_status=None

    def read(self):
        try:
            value=json.loads((self.directory/'page-command.json').read_text(encoding='utf-8'))
        except PermissionError:
            if os.name!='nt' or self.command is None: raise
            value=self.command  # Windows replace/read race; original heartbeat still expires.
        if (value.get('schema')!='hand-page-command-v1' or value.get('session')!=self.session
            or value.get('game_run')!=self.game_run or value.get('mode') not in ('live','idle','demo')
            or type(value.get('generation')) is not int or value['generation']<self.generation
            or type(value.get('sent_at')) not in (float,int) or not math.isfinite(value['sent_at'])):
            raise ValueError('Page command identity, generation or heartbeat invalid')
        if self.command is not None and value['generation']==self.generation and value['mode']!=self.command['mode']:
            raise ValueError('Page command generation reused with different mode')
        age=self.clock()-value['sent_at']
        if age<0:raise ValueError('Page command heartbeat is in the future')
        if age>=2:
            raise PageHeartbeatExpired('Page command heartbeat expired: age={:.6f}s, generation={}, mode={}'.format(
                age,value['generation'],value['mode']))
        self.command=value
        self.generation=value['generation']
        return value['mode'],value['generation']

    def publish(self,value):
        value=dict(value,schema='hand-page-state-v1',session=self.session,game_run=self.game_run)
        if value==self.last_status: return
        temporary=self.directory/'page-state.tmp'
        temporary.write_text(json.dumps(value),encoding='utf-8')
        try:
            temporary.replace(self.directory/'page-state.json')
        except PermissionError:
            if os.name!='nt': raise
            return  # Retry next lifecycle tick, without claiming publication.
        self.last_status=value


class PagePlayback:
    def __init__(self,channel):
        self.channel=channel
        self.mode='idle'
        self.generation=-1
        self.index=0
        self.finishing=False
        self.completed=False
        self.interrupted=False
        self.pending=None
        self.last_renew=-math.inf
        self.transition_started=None
        self.live_granted=False
        self.waiting_command=False
        self.command_gaps=0
        self.command_resumes=0
        self.follow_status=None
        self.follow_published_at=-math.inf
        self.follow_counts={}
        self.follow_classes={'paper':0,'fist':0,'scissors':0,'unknown':0,'invalid':0}
        self.follow_last_frame=-1
        self.follow_accepts=[]

    def record_follow(self,controller,reason,observation,now,*,source_waits=0,source_resumes=0,overload_waits=0):
        """Bounded normal diagnostics on the existing channel, no motor READ.

        At most one diagnostic update/second, except a newly approved action.
        Page ownership transitions themselves remain immediate.
        """
        self.follow_counts[reason]=self.follow_counts.get(reason,0)+1
        if observation is not None and observation.frame_id>self.follow_last_frame:
            self.follow_last_frame=observation.frame_id
            label=(observation.gesture if observation.valid and observation.gesture in
                   ('paper','fist','scissors') else 'unknown' if observation.valid else 'invalid')
            self.follow_classes[label]+=1
        if reason!='accepted' and now-self.follow_published_at<1:
            return
        status=controller.status()
        operation=status.get('operation')
        self.follow_status=dict(decision=reason,observed_at=now,
            frame_id=None if observation is None else observation.frame_id,
            gesture=None if observation is None else observation.gesture,
            source_age_ms=None if observation is None else max(0.,(now-observation.source_at)*1000),
            request_id=None if operation is None else operation['request_id'],
            state=None if operation is None else operation.get('state'),
            source_waits=source_waits,source_resumes=source_resumes,overload_waits=overload_waits)
        self.follow_published_at=now
        if reason=='accepted':
            self.follow_accepts.append(dict(generation=self.generation,mode=self.mode,
                observed_at=now,frame_id=None if observation is None else observation.frame_id,
                gesture=None if observation is None else observation.gesture,
                request_id=None if operation is None else operation['request_id'],
                state=None if operation is None else operation.get('state')))
            del self.follow_accepts[:-16]
        self._publish(controller,'WAITING_SOURCE' if reason=='waiting_source' else 'LIVE')

    def interrupt(self):
        # Preview/shutdown wins. A previous generation may never replay itself.
        if self.mode=='demo':
            self.interrupted=True
            self.finishing=True

    def _settle(self,status):
        if self.pending is None:
            return
        operation=status['operation'] or {}
        if operation.get('request_id')!=self.pending[0] or operation.get('status')!='played':
            raise RuntimeError('Page playback completion mismatch')
        if self.pending[1]=='final': self.completed=True
        else: self.index+=1
        self.pending=None

    def _publish(self,controller,phase):
        status=controller.status()
        life=status['lifecycle']
        stage=getattr(controller,'playback_stage',None)
        pose='default' if stage is None or stage.startswith('default:') else stage.rsplit(':',1)[0]
        off=(life=='CONNECTED_OFF' and status['enable_epoch'] is None
             and not controller.release_pending and not status['error'])
        self.channel.publish(dict(generation=self.generation,mode=self.mode,phase=phase,
            pose=pose,index=self.index,off=off,command_gaps=self.command_gaps,
            command_resumes=self.command_resumes,
            release_confirmed_ids=list(range(1,18)) if off else [],
            lifecycle=life,enable_epoch=status['enable_epoch'],follow=self.follow_status,
            follow_counts=dict(self.follow_counts),follow_classes=dict(self.follow_classes),
            follow_accepts=list(self.follow_accepts)))

    def tick(self,controller,now):
        fresh=True
        try:
            mode,generation=self.channel.read()
        except PageHeartbeatExpired:
            fresh=False
            if not self.waiting_command:
                self.waiting_command=True
                self.command_gaps+=1
            self.live_granted=False
        status=controller.status()
        if status['error']:
            raise RuntimeError(status['error'])
        life=status['lifecycle']
        if life not in ('READY_IDLE','MOVING','CONNECTED_OFF','ARMING','RELEASING'):
            raise RuntimeError('Invalid page owner lifecycle: '+life)
        if life in ('ARMING','RELEASING') or controller.release_pending:
            if self.transition_started is None: self.transition_started=now
            if now-self.transition_started>10: raise TimeoutError('Page ownership transition timed out')
        else: self.transition_started=None
        if life in ('READY_IDLE','MOVING') and not controller.release_pending and now-self.last_renew>=.2:
            controller.renew(session_id=status['session_id'],enable_epoch=status['enable_epoch'])
            self.last_renew=now
        if self.waiting_command:
            # Complete only the already approved bounded move, consume its receipt
            # exactly once, then confirm OFF before accepting any fresh authority.
            # A heartbeat gap is not a cancellation of the demonstration.
            if life=='READY_IDLE' and not controller.release_pending:
                self._settle(status)
                controller.pause_for_preview()
            elif life=='ARMING' and not controller.release_pending:
                controller.pause_for_preview()
            status=controller.status()
            off=(status['lifecycle']=='CONNECTED_OFF' and status['enable_epoch'] is None
                 and not controller.release_pending and not status['error'])
            if not fresh or not off:
                self._publish(controller,'WAITING_COMMAND')
                return True
            self.waiting_command=False
            self.command_resumes+=1
            self.transition_started=None
            life=status['lifecycle']
        changed=generation!=self.generation
        if changed:
            self.mode,self.generation=mode,generation
            self.index=0; self.completed=False; self.interrupted=False
            self.finishing=mode!='demo'
            self.pending=None
            self.live_granted=False
        phase='WAITING'
        if mode=='live' and not self.interrupted:
            if life=='CONNECTED_OFF' and not controller.release_pending: controller.resume_preview()
            if life=='READY_IDLE':
                self.live_granted=True
                self._publish(controller,'LIVE')
                return False
            if life=='MOVING' and self.live_granted:
                self._publish(controller,'LIVE')
                return False  # Keep the same consumer and its last-sent latch.
        elif life=='CONNECTED_OFF' and not controller.release_pending:
            if mode=='demo' and not self.completed and not self.interrupted:
                controller.resume_preview()
                phase='STARTING'
            else:
                phase='INTERRUPTED' if self.interrupted else 'DONE' if self.completed and mode=='demo' else 'IDLE'
        elif life=='MOVING':
            phase='RETURNING' if mode!='demo' or self.finishing else 'PLAYING'
        elif life=='READY_IDLE' and not controller.release_pending:
            self._settle(status)
            if mode=='demo' and not self.interrupted and not self.completed and self.index<len(DEMO_STATES):
                state=DEMO_STATES[self.index]
                phase='PLAYING'
                kind='demo'
            elif status['estimated_state']!='default' or mode=='demo' and not self.completed and not self.interrupted:
                state='default'; kind='final'; self.finishing=True; phase='RETURNING'
            else:
                controller.pause_for_preview()
                state=None; phase='RELEASING'
            if state is not None:
                request=controller.last_request+1
                if controller.submit(state,request_id=request,session_id=status['session_id'],enable_epoch=status['enable_epoch'])!='accepted':
                    raise RuntimeError('Page playback approval rejected')
                self.pending=(request,kind)
        self._publish(controller,phase)
        return True
