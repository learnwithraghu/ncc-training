# Topic 12: Case Statements and Menu Routing

**Time:** 20 minutes

## Goal
Use `case` to simplify menu-driven scripts.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > case_demo.sh << 'EOF'
#!/bin/bash

read -p "Choose 1, 2, or 3: " OPTION

case "$OPTION" in
  1) echo "You chose option 1" ;;
  2) echo "You chose option 2" ;;
  3) echo "You chose option 3" ;;
  *) echo "Invalid option" ;;
esac
EOF
chmod +x case_demo.sh
./case_demo.sh
```

## Guided Steps
1. Build a small menu prompt.
2. Route each choice with `case`.
3. Add a default branch for invalid input.
4. Compare this with a long `if/elif/else` chain.
5. Explain why `case` is easier to read for menus.

## Checkpoint
Why is `case` a good fit for menus with several options?
