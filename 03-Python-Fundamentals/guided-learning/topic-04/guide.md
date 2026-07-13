# Topic 4: Conditionals and Comparisons

**Time:** 20 minutes

## Goal
Use `if`, `elif`, and `else` to make decisions.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi conditionals.py
python3 conditionals.py
```

## Guided Steps
1. Open `vi conditionals.py` and add the script content below.
2. Use `if`, `elif`, and `else`.
3. Change the status code to 404 and 200.
4. Explain how comparisons guide the logic flow.
5. Mention how this pattern appears in automation checks.

## Checkpoint
When would you use `elif` instead of a separate `if`?

## Script Content
```python
status_code = 500

if status_code >= 500:
    print('Server error')
elif status_code >= 400:
    print('Client error')
else:
    print('OK')
```
