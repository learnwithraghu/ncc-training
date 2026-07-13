# Topic 1: Python Setup and First Script

**Time:** 20 minutes

## Goal
Set up Python and run a first script.

## Commands to Use
```bash
python3 --version
cd ~/ncc-labs/day1
cat > hello.py << 'EOF'
#!/usr/bin/env python3
print('Hello from Python!')
EOF
python3 hello.py
```

## Guided Steps
1. Verify Python 3 is installed.
2. Create a file called `hello.py`.
3. Add the Python shebang and a print statement.
4. Run the script with `python3 hello.py`.
5. Explain why the shebang is useful even when you run with `python3`.

## Checkpoint
What does the shebang line tell the system?
