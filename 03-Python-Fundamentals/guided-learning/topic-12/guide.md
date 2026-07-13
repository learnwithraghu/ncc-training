# Topic 12: Paths and File System Work

**Time:** 20 minutes

## Goal
Work with paths and folders in a portable way.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi path_demo.py
python3 path_demo.py
```

## Guided Steps
1. Open `vi path_demo.py` and add the script content below.
2. Import `Path` from `pathlib`.
3. Build a path from smaller parts.
4. Print the resulting path.
5. Check whether it exists.
6. Explain why `pathlib` is easier to read than string concatenation.

## Checkpoint
What advantage does `pathlib` have over joining strings by hand?

## Script Content
```python
from pathlib import Path

base_dir = Path.home() / 'ncc-labs' / 'day1'
print(base_dir)
print(base_dir.exists())
```
