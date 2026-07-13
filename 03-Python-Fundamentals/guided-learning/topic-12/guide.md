# Topic 12: Paths and File System Work

**Time:** 20 minutes

## Goal
Work with paths and folders in a portable way.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > path_demo.py << 'EOF'
from pathlib import Path

base_dir = Path.home() / 'ncc-labs' / 'day1'
print(base_dir)
print(base_dir.exists())
EOF
python3 path_demo.py
```

## Guided Steps
1. Import `Path` from `pathlib`.
2. Build a path from smaller parts.
3. Print the resulting path.
4. Check whether it exists.
5. Explain why `pathlib` is easier to read than string concatenation.

## Checkpoint
What advantage does `pathlib` have over joining strings by hand?
