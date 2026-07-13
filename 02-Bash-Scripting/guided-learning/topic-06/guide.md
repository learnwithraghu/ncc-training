# Topic 6: Functions and Arguments

**Time:** 20 minutes

## Goal
Organize repeated logic into functions.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > function_demo.sh << 'EOF'
#!/bin/bash
greet() {
  echo "Hello, $1"
}
greet "Alice"
greet "Bob"
EOF
chmod +x function_demo.sh
./function_demo.sh
```

## Guided Steps
1. Create a function that prints a greeting.
2. Pass values into the function.
3. Use `$1` inside the function.
4. Run the script and observe the repeated pattern.
5. Explain why functions make scripts easier to maintain.

## Checkpoint
How do function arguments differ from script arguments?
