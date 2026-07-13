# Solution: Variables and Input

## Script
```bash
#!/bin/bash

read -p "Enter your name: " name

if [[ -z "$name" ]]; then
  echo "You did not enter a name."
else
  echo "Hello, $name"
fi
```

## Notes
- `read -p` prompts for input.
- `[[ -z "$name" ]]` checks whether the variable is empty.