import os
from pathlib import Path

script_root = Path(os.path.realpath(__file__))
parent_dir = Path((script_root.parent.absolute()).parent.absolute())
