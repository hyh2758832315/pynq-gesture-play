"""Read the installed PYNQ MMIO Python implementation; no PYNQ import/MMIO."""
from board_common import remote

source='''import ast,hashlib,json,pathlib
path=pathlib.Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/mmio.py')
data=path.read_bytes()
text=data.decode('utf-8')
tree=ast.parse(text)
methods={node.name:ast.get_source_segment(text,node) for node in ast.walk(tree)
         if isinstance(node,ast.FunctionDef) and node.name in ('__init__','read','write','write_mm','write_reg')}
print(json.dumps(dict(path=str(path),sha256=hashlib.sha256(data).hexdigest(),methods=methods)),flush=True)
'''

if __name__=='__main__': remote('g23-pynq-mmio-api-readonly',source)
