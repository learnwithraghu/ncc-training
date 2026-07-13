# Topic 8: Functions and Scope

**Time:** 20 minutes

## Goal
Package repeated logic into functions.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi functions_demo.py
python3 functions_demo.py
```

## Guided Steps
1. Open `vi functions_demo.py` and add the script content below.
2. Define a function that takes one argument.
2. Call the function several times.
3. Use a loop to drive the function.
4. Talk about local variables and scope.
5. Explain why functions make scripts easier to test.

## Checkpoint
What is the benefit of putting repeated work in a function?

## Script Content
```python
def greet(name):
    print(f'Hello, {name}')

for person in ['Alice', 'Bob', 'Charlie']:
    greet(person)
```
