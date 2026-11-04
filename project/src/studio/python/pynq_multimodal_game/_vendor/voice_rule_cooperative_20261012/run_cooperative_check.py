"""Explicit18s cooperative audio-only check; no game or automatic recovery."""
from pathlib import Path
import importlib.util

if __name__=='__main__':
    root=Path(__file__).resolve().parent
    spec=importlib.util.spec_from_file_location('_cooperative_rules_runner',root/'run_live_voice_test.py')
    runner=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    print('18秒声音检查：不加载BIT、不控制游戏；看到LIVE_READY再说话。',flush=True)
    runner.main(['--rules-18s','--reset-audio-dma-before-record','--cpu-worker',
        '--poll-budget-ms','15','--optimize-receive','--pin-cpu','--energy-onset-candidate',
        '--control-budget','--pll-budget','--health-budget','--cooperative-deadlines'])
