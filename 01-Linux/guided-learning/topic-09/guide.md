# Topic 9: Search with grep and find

**Time:** 20 minutes

## Goal
Find text and files quickly.

## Commands to Use
```bash
grep -n "error" sample.log
grep -i "fail" sample.log
find . -name "*.txt"
find . -type f
```

## Guided Steps
1. Create or open a log-style file.
2. Search for a word with `grep`.
3. Use `-i` to ignore case.
4. Use `find` to locate files by name.
5. Use `find` to list only files, not folders.

## Checkpoint
What problem does `grep` solve that `find` does not?
