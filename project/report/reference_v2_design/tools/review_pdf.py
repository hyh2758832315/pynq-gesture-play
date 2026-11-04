"""Render report pages and review sheets; run from any directory with bundled Python.
Output: qa/page_*.png, qa/contact_*.png, qa/text.txt, qa/review.json.
Next: visually inspect all sheets and detailed pages, then record the review.
"""
from pathlib import Path
import json, hashlib
import pypdfium2 as pdfium
from pypdf import PdfReader
from PIL import Image, ImageDraw

root=Path(__file__).resolve().parents[1]
pdfpath=root/'gesture_play_v2_junior.pdf'
doc=pdfium.PdfDocument(pdfpath)
qa=root/'qa';qa.mkdir(exist_ok=True)
thumbs=[]
for i,page in enumerate(doc):
    im=page.render(scale=1.5).to_pil().convert('RGB')
    im.save(qa/f'page_{i+1:02}.png')
    im.thumbnail((397,562))
    tile=Image.new('RGB',(417,592),'#d8dfe3');tile.paste(im,((417-im.width)//2,20))
    ImageDraw.Draw(tile).text((10,575),str(i+1),fill='black')
    thumbs.append(tile)
for start in range(0,len(thumbs),6):
    sheet=Image.new('RGB',(1251,1184),'white')
    for j,tile in enumerate(thumbs[start:start+6]):sheet.paste(tile,((j%3)*417,(j//3)*592))
    sheet.save(qa/f'contact_{start//6+1:02}.png')
reader=PdfReader(pdfpath)
texts=[p.extract_text() for p in reader.pages]
(qa/'text.txt').write_text('\n\n'.join(texts),encoding='utf-8')
result={'pages':len(texts),'pdf_sha256':hashlib.sha256(pdfpath.read_bytes()).hexdigest(),'characters':sum(map(len,texts)),'visual_review':'pending','page_text_lengths':[len(t) for t in texts]}
(qa/'review.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False))
