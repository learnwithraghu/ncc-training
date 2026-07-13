# Solution: Loops and Functions

## Script
```bash
#!/bin/bash

print_status() {
  echo "Processing: $1"
}

for item in alpha beta gamma; do
  print_status "$item"
done
```

## Notes
- Functions keep repeated logic in one place.
- The loop passes each item into the function as an argument.