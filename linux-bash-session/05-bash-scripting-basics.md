# Module 3: Bash Scripting Basics (30 Minutes)

## Goal
Write your first shell scripts to automate tasks using variables, loops, and conditions.

## 1. What is a Script?
A script is a file containing a series of commands.
*   **Shebang:** The first line `#!/bin/bash` tells the system which interpreter to use.

## 2. Your First Script
Create a file named `hello.sh`:
```bash
#!/bin/bash
echo "Hello, World!"
```
Make it executable and run it:
```bash
chmod +x hello.sh
./hello.sh
```

## 3. Variables
```bash
#!/bin/bash
NAME="Alice"            # No spaces around =
echo "Hello, $NAME"
```

## 4. Input
```bash
#!/bin/bash
echo "What is your name?"
read USER_NAME
echo "Nice to meet you, $USER_NAME"
```

## 5. Conditions (`if/else`)
```bash
#!/bin/bash
echo "Enter a number:"
read NUM

if [ $NUM -gt 10 ]; then
    echo "The number is greater than 10."
else
    echo "The number is 10 or less."
fi
```
*   `-gt`: Greater than
*   `-lt`: Less than
*   `-eq`: Equal to

## Hands-on Exercise 3
1.  Create a script named `greet.sh`.
2.  Ask the user for their name and favorite color.
3.  Print a message using those variables (e.g., "Hi Alice, I see you like Blue!").
4.  Add a check: if the color is "red", print "Red is a bold choice!".
