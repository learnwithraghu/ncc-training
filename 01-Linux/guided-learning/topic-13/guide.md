# Topic 13: Redirection and Pipes

**Time:** 20 minutes

## Goal
Send command output into files and into other commands.

## Commands to Use
```bash
echo "hello" > notes.txt
echo "another line" >> notes.txt
cat notes.txt | grep line
ls /no/such/path 2> errors.txt
cat notes.txt | tee copy.txt
```

## Guided Steps
1. Write output to a file with `>`.
2. Append output with `>>`.
3. Pipe one command into another with `|`.
4. Redirect errors with `2>`.
5. Use `tee` if you want to see output and save it.

## Checkpoint
What is the difference between `>` and `>>`?
