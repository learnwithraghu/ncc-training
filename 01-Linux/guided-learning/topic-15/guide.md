# Topic 15: Linux Mini Workflow

**Time:** 20 minutes

## Goal
Combine the skills from the earlier topics into one short workflow.

## Commands to Use
```bash
mkdir -p mini-workflow/logs
cd mini-workflow
echo "step 1 complete" > notes.txt
echo "step 2 complete" >> notes.txt
grep -n "complete" notes.txt
tar -czf mini-workflow.tar.gz .
```

## Guided Steps
1. Create a small working folder.
2. Add a note file and append to it.
3. Search the file for a keyword.
4. Archive the folder when you are finished.
5. Explain which commands you used and why.

## Checkpoint
Show how this mini workflow uses navigation, file creation, search, and archiving together.
