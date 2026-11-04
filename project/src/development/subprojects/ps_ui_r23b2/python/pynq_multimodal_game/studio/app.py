from __future__ import annotations

import sys
from collections.abc import Sequence


def main(arguments: Sequence[str] | None = None) -> int:
    try:
        from .qt_app import run_studio
    except ModuleNotFoundError as error:
        if error.name != "PySide6":
            raise
        print(
            "Voice View Studio requires the optional GUI dependencies. "
            "Install them with: python -m pip install -e .[studio]",
            file=sys.stderr,
        )
        return 2
    return run_studio(arguments)


if __name__ == "__main__":
    raise SystemExit(main())