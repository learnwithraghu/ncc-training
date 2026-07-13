# Topic 14: Archives and Compression

**Time:** 20 minutes

## Goal
Package files into an archive and extract them again.

## Commands to Use
```bash
mkdir archive-demo
touch archive-demo/a.txt archive-demo/b.txt
tar -czf archive-demo.tar.gz archive-demo
tar -xzf archive-demo.tar.gz
gzip notes.txt
gunzip notes.txt.gz
```

## Guided Steps
1. Create a small folder with a few files.
2. Archive it with `tar -czf`.
3. Extract the archive with `tar -xzf`.
4. Compress a single file with `gzip`.
5. Restore it with `gunzip`.

## Checkpoint
When would you use `tar` instead of `gzip`?
