# Topic 6: File Permissions

**Time:** 20 minutes

## Goal
Read permission bits and make a file executable.

## Commands to Use
```bash
touch script.sh
ls -l script.sh
chmod u+x script.sh
chmod 644 script.sh
chmod 755 script.sh
```

## Guided Steps
1. Create a script file.
2. Check the permission string with `ls -l`.
3. Add execute permission for the owner with `chmod u+x`.
4. Practice numeric modes like `644` and `755`.
5. Compare the permission output before and after.

## Checkpoint
What does the `x` bit allow you to do?
