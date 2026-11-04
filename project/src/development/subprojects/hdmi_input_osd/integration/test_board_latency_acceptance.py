import copy
import ast
from types import SimpleNamespace
import unittest
from unittest.mock import Mock, patch

import board_latency_acceptance
import continue_r1


def snapshot(frame=1, monitor=1, commits=0, cpu_ns=0):
    return dict(volume=dict(error=None, sampling_enabled=True, poller_alive=True,
                           worker=dict(faults=0, ack_error=False, monitor_count=monitor)),
                vision=dict(state='RUNNING', last_error=None, frame_id=frame,
                            hdmi_osd=dict(thread_alive=True, error=None, commits=commits,
                                          cpu_ns=cpu_ns, last_tick_age_ms=40.,
                                          audio_source=dict(age_ms=60.,healthy=True),
                                          last_submitted_words=[9])))


class AcceptanceTests(unittest.TestCase):
    def observer(self, first=None, last=None, limit=None):
        observer=board_latency_acceptance.Acceptance.__new__(board_latency_acceptance.Acceptance)
        observer.args=SimpleNamespace(candidate=None, max_osd_cpu_percent=limit)
        observer.record=dict(summaries=[])
        observer.command=Mock(side_effect=[dict(snapshot=first or snapshot()),
            dict(snapshot=last or snapshot(frame=7, monitor=51, commits=27, cpu_ns=24800000))])
        return observer

    def observe(self, observer):
        with patch.object(board_latency_acceptance.time,'monotonic',side_effect=[0.,0.,1.,1.]), \
                patch.object(board_latency_acceptance.threading,'Event'):
            return observer.observe(1.,'unit-no-hardware')

    def test_r1_accepted_cpu_is_reported_without_historical_one_percent_gate(self):
        observer=self.observer()
        self.observe(observer)
        summary=observer.record['summaries'][0]
        self.assertAlmostEqual(summary['osd_thread_one_core_percent'],2.48)
        self.assertEqual(summary['osd_cpu_reference_one_core_percent'],2.47960994)
        self.assertIsNone(summary['osd_cpu_limit_percent'])

    def test_explicit_cpu_budget_is_enforced(self):
        with self.assertRaises(AssertionError):
            self.observe(self.observer(limit=1.))
        self.observe(self.observer(limit=3.))

    def test_invalid_cpu_measurement_is_rejected(self):
        for value in (-1,float('nan'),1000000001):
            with self.subTest(value=value), self.assertRaises(AssertionError):
                self.observe(self.observer(last=snapshot(frame=7, monitor=51, commits=27, cpu_ns=value)))

    def test_source_stall_remains_a_failure(self):
        for field in ('vision','volume'):
            last=snapshot(frame=7, monitor=51, commits=27, cpu_ns=24800000)
            if field=='vision':
                last['vision']['frame_id']=1
            else:
                last['volume']['worker']['monitor_count']=1
            with self.subTest(field=field), self.assertRaises(AssertionError):
                self.observe(self.observer(last=last))

    def test_tick_age_and_audio_validity_remain_failures(self):
        for field,value in (('last_tick_age_ms',100.),('last_submitted_words',[1])):
            last=snapshot(frame=7, monitor=51, commits=27, cpu_ns=24800000)
            last['vision']['hdmi_osd'][field]=value
            with self.subTest(field=field), self.assertRaises(AssertionError):
                self.observe(self.observer(last=last))

    def test_fault_and_ack_errors_are_rejected(self):
        for field in ('faults','ack_error'):
            observed=copy.deepcopy(snapshot())
            observed['volume']['worker'][field]=1
            with self.subTest(field=field), self.assertRaises(AssertionError):
                self.observe(self.observer(first=observed))

    def test_resource_sampler_tolerates_a_thread_exiting_during_enumeration(self):
        tree=ast.parse(continue_r1.SAMPLER)
        helper=next(node for node in tree.body if isinstance(node,ast.FunctionDef) and node.name=='task_names')
        namespace={}
        exec(compile(ast.Module(body=[helper],type_ignores=[]),'<sampler-helper>','exec'),namespace)
        exited=Mock(name='exited');exited.name='11'
        exited.joinpath.return_value.read_text.side_effect=FileNotFoundError('thread exited')
        live=Mock(name='live');live.name='12'
        live.joinpath.return_value.read_text.return_value='python\n'
        process=Mock();process.joinpath.return_value.iterdir.return_value=[exited,live]
        self.assertEqual(namespace['task_names'](process),{'12':'python'})

    def test_video_pause_allows_only_one_admitted_frame_then_requires_freeze(self):
        paused=dict(state='paused',presented_frames=17,frame_index=17)
        drained=dict(state='paused',presented_frames=18,frame_index=18)
        board_latency_acceptance.validate_video_pause(paused,paused,drained,drained,drained)
        for changed in (dict(drained,presented_frames=19),dict(drained,state='running')):
            with self.subTest(changed=changed),self.assertRaises(AssertionError):
                board_latency_acceptance.validate_video_pause(paused,paused,changed,changed,changed)
        with self.assertRaises(AssertionError):
            board_latency_acceptance.validate_video_pause(paused,paused,drained,drained,dict(drained,presented_frames=19))

    def test_disabled_osd_keeps_the_same_audio_source_health_and_ttl_gate(self):
        first=snapshot();last=snapshot(frame=7,monitor=51,commits=27,cpu_ns=24800000)
        for item in (first,last):
            item['vision']['hdmi_osd'].update(enabled=False,last_submitted_words=[0])
        self.observe(self.observer(first=first,last=last))
        for key,value in (('healthy',False),('age_ms',100.)):
            invalid=copy.deepcopy(first)
            invalid['vision']['hdmi_osd']['audio_source'][key]=value
            with self.subTest(key=key),self.assertRaises(AssertionError):
                self.observe(self.observer(first=invalid,last=last))

    def test_age_distributions_preserve_missing_and_single_sample_boundaries(self):
        self.assertIsNone(board_latency_acceptance.distribution([None]))
        self.assertEqual(board_latency_acceptance.distribution([5]),dict(count=1,p50=5,p95=5,p99=5,maximum=5))
        result=board_latency_acceptance.distribution(range(101))
        self.assertEqual((result['p50'],result['p95'],result['p99'],result['maximum']),(50,95,99,100))


if __name__=='__main__':
    unittest.main()