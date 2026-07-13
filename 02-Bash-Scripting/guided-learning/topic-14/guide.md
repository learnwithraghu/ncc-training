# Topic 14: Debugging and Tracing

**Time:** 20 minutes

## Goal
Use Bash tracing to understand script behavior.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > trace_demo.sh << 'EOF'
#!/bin/bash
set -x

NAME="student"
echo "Hello, $NAME"
set +x
echo "Tracing stopped"
EOF
chmod +x trace_demo.sh
./trace_demo.sh
```

## Guided Steps
1. Turn tracing on with `set -x`.
2. Run a few simple commands.
3. Turn tracing off with `set +x`.
4. Explain how tracing helps debug scripts.
5. Use the output to follow each command step by step.

## Checkpoint
When would you use `set -x` during script development?
