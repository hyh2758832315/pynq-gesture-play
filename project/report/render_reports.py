"""Build the public performance PDFs from their editable HTML sources.

Run: python -m pip install reportlab beautifulsoup4
     python report/render_reports.py
Requires Windows Microsoft YaHei regular/bold fonts; --font-dir overrides the directory.
Outputs: gpu_ai_preparation/gpu_optimization_report.pdf and
reference_v2_performance/performance_resource_report.pdf beside this script.
Next: render each PDF and inspect page layout before publication.
"""
from pathlib import Path
import argparse,html
from bs4 import BeautifulSoup,Tag
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Table,TableStyle,Image,PageBreak,KeepTogether

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--font-dir',type=Path,default=Path('C:/Windows/Fonts'))
    args=ap.parse_args();root=Path(__file__).resolve().parent
    pdfmetrics.registerFont(TTFont('Chinese',str(args.font_dir/'msyh.ttc')))
    pdfmetrics.registerFont(TTFont('ChineseBold',str(args.font_dir/'msyhbd.ttc')))
    pdfmetrics.registerFontFamily('Chinese',normal='Chinese',bold='ChineseBold',italic='Chinese',boldItalic='ChineseBold')
    styles={
      'title':ParagraphStyle('title',fontName='ChineseBold',fontSize=22,leading=29,spaceAfter=12,keepWithNext=True),
      'h':ParagraphStyle('h',fontName='ChineseBold',fontSize=15,leading=22,spaceAfter=10,keepWithNext=True),
      'body':ParagraphStyle('body',fontName='Chinese',fontSize=10,leading=16,spaceAfter=8,wordWrap='CJK'),
      'small':ParagraphStyle('small',fontName='Chinese',fontSize=8.5,leading=13,spaceAfter=7,wordWrap='CJK',textColor=colors.HexColor('#404040')),
      'cell':ParagraphStyle('cell',fontName='Chinese',fontSize=8.5,leading=13,wordWrap='CJK'),
      'tabletitle':ParagraphStyle('tabletitle',fontName='ChineseBold',fontSize=10,leading=15,spaceBefore=5,spaceAfter=6,keepWithNext=True)}
    width=A4[0]-84
    def para(text,style='body'):return Paragraph(html.escape(text).replace('\n','<br/>'),styles[style])
    for folder,pdfname in [('gpu_ai_preparation','gpu_optimization_report.pdf'),('reference_v2_performance','performance_resource_report.pdf')]:
        base=root/folder;soup=BeautifulSoup((base/'chapter.html').read_text('utf-8'),'html.parser');story=[]
        def walk(node):
            if not isinstance(node,Tag):return
            tag=node.name;cl=node.get('class',[])
            if tag in ('p','h1','h2','h3'):
                style='title' if tag=='h1' or 'title' in cl else 'h' if tag in ('h2','h3') or 'h' in cl else 'tabletitle' if 'tabletitle' in cl or 'th' in cl else 'small' if 'small' in cl or 'caption' in cl else 'body'
                story.append(para(node.get_text(' ',strip=True),style))
            elif tag=='figure':
                img=node.find('img');cap=node.find('figcaption')
                if img:
                    p=base/img['src'];p=p.with_suffix('.png') if p.suffix=='.svg' and p.with_suffix('.png').exists() else p
                    if p.suffix=='.svg':raise ValueError('PNG counterpart required: '+str(p))
                    obj=Image(str(p));scale=min(width/obj.imageWidth,225/obj.imageHeight)
                    obj.drawWidth=obj.imageWidth*scale;obj.drawHeight=obj.imageHeight*scale
                    block=[obj,Spacer(1,5)]
                    if cap:block.append(para(cap.get_text(' ',strip=True),'small'))
                    story.append(KeepTogether(block))
            elif tag=='table':
                rows=[[para(c.get_text(' ',strip=True),'cell') for c in tr.find_all(['td','th'],recursive=False)] for tr in node.find_all('tr')]
                if not rows:return
                cols=max(map(len,rows));weights=[1]*cols
                if cols==2:weights=[.30,.70]
                if cols==3:weights=[.21,.36,.43]
                if cols==4:weights=[.32,.28,.15,.25]
                t=Table(rows,colWidths=[width*w/sum(weights) for w in weights],repeatRows=1,hAlign='LEFT')
                t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#eeeeee')),('VALIGN',(0,0),(-1,-1),'TOP'),('LINEBELOW',(0,0),(-1,0),.6,colors.black),('LINEBELOW',(0,-1),(-1,-1),.4,colors.grey),('LEFTPADDING',(0,0),(-1,-1),6),('RIGHTPADDING',(0,0),(-1,-1),6),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
                story.extend([t,Spacer(1,10)])
            elif tag in ('ul','ol'):
                for i,li in enumerate(node.find_all('li',recursive=False),1):story.append(para(f'{i}. '+li.get_text(' ',strip=True)))
            else:
                for child in node.children:walk(child)
        sections=soup.body.find_all('section',recursive=False)
        for n,section in enumerate(sections):
            if n:story.append(PageBreak())
            walk(section)
        title=soup.title.get_text() if soup.title else 'GESTURE PLAY'
        def footer(canvas,doc):
            canvas.saveState();canvas.setFont('Chinese',8);canvas.setFillColor(colors.grey)
            canvas.drawString(42,26,'GESTURE PLAY');canvas.drawRightString(A4[0]-42,26,str(doc.page));canvas.restoreState()
        doc=SimpleDocTemplate(str(base/pdfname),pagesize=A4,rightMargin=42,leftMargin=42,topMargin=38,bottomMargin=42,title=title,author='',subject='设计方法、实验条件与测量结果')
        doc.build(story,onFirstPage=footer,onLaterPages=footer)
        print(base/pdfname)

if __name__=='__main__':main()
