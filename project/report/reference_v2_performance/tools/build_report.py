"""Rebuild both performance PDFs from the packaged editable HTML.
Run: python tools/build_report.py. Requires reportlab, beautifulsoup4 and Chinese fonts.
Outputs: the two report PDFs. Next: render and inspect pages.
"""
from pathlib import Path
import runpy
runpy.run_path(str(Path(__file__).resolve().parents[2]/'render_reports.py'),run_name='__main__')
