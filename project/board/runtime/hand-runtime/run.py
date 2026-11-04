from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

from pynq_usb_hand.cli import main
import pynq_usb_hand


if not Path(pynq_usb_hand.__file__).resolve().is_relative_to(ROOT / "src"):
    raise RuntimeError("Another controller copy is already imported")


if __name__ == "__main__":
    raise SystemExit(main(["--root", str(ROOT), *sys.argv[1:]]))