"""Add missing Fandol CID-to-Unicode maps without changing page appearance.

Usage: python tools/repair_pdf_unicode.py main.pdf Scene2D_GPU_midterm.pdf
Requires pypdf and fonttools. Pass --font-dir for a TeX fonts directory if needed.
"""
from __future__ import annotations

import argparse
import os
import unicodedata
from pathlib import Path

from fontTools.ttLib import TTFont
from pypdf import PdfReader, PdfWriter
from pypdf.generic import DecodedStreamObject, NameObject


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--font-dir", type=Path)
    args = parser.parse_args()
    if args.input.resolve() == args.output.resolve():
        parser.error("Input and output must be different files.")
    roots = [args.font_dir] if args.font_dir else [
        Path(os.environ.get("LOCALAPPDATA", Path.home() / "AppData/Local"))
        / "TectonicProject/Tectonic/cache/bundles/data",
        Path.home() / ".cache/Tectonic",
        Path("/usr/share/texlive/texmf-dist/fonts/opentype/public/fandol"),
    ]
    writer = PdfWriter(clone_from=PdfReader(args.input))
    seen: set[int] = set()
    repaired = []
    for page in writer.pages:
        for reference in page["/Resources"].get("/Font", {}).values():
            font = reference.get_object()
            if id(font) in seen:
                continue
            seen.add(id(font))
            name = str(font.get("/BaseFont", "")).split("+")[-1]
            name = name.removesuffix("-Identity-H").lstrip("/")
            if not name.startswith("Fandol") or "/ToUnicode" in font:
                continue
            candidates = [p for root in roots if root and root.exists()
                          for p in root.rglob(name + ".otf")]
            if not candidates:
                raise FileNotFoundError(f"Pass --font-dir containing {name}.otf")
            with TTFont(candidates[0]) as original:
                mapping = {}
                for char, glyph in original.getBestCmap().items():
                    if glyph.startswith("cid"):
                        normalized = unicodedata.normalize("NFKC", chr(char))
                        canonical = ord(normalized) if len(normalized) == 1 else char
                        mapping.setdefault(int(glyph[3:]), canonical)
            if not mapping:
                raise ValueError(f"No CID-keyed cmap found for {name}")
            lines = ["/CIDInit /ProcSet findresource begin", "12 dict begin",
                     "begincmap", "/CIDSystemInfo << /Registry (Adobe) /Ordering (UCS) /Supplement 0 >> def",
                     "/CMapName /FandolUnicode def", "/CMapType 2 def",
                     "1 begincodespacerange", "<0000> <FFFF>", "endcodespacerange"]
            items = sorted(mapping.items())
            for start in range(0, len(items), 100):
                chunk = items[start:start + 100]
                lines.append(f"{len(chunk)} beginbfchar")
                for cid, char in chunk:
                    unicode_hex = chr(char).encode("utf-16-be").hex().upper()
                    lines.append(f"<{cid:04X}> <{unicode_hex}>")
                lines.append("endbfchar")
            lines.extend(["endcmap", "CMapName currentdict /CMap defineresource pop", "end", "end"])
            stream = DecodedStreamObject()
            stream.set_data("\n".join(lines).encode("ascii"))
            font[NameObject("/ToUnicode")] = stream
            repaired.append(name)
    with args.output.open("wb") as handle:
        writer.write(handle)
    extracted = "\n".join(page.extract_text() for page in PdfReader(args.output).pages)
    if "二维图形处理器" not in extracted:
        raise RuntimeError("Chinese extraction check failed.")
    print(f"Unicode maps added: {', '.join(repaired) or 'already present'}")
    print(f"Output: {args.output}")


if __name__ == "__main__":
    main()
