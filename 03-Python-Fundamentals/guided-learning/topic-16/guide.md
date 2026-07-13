# Topic 16: Config File Validation

**Time:** 20 minutes

## Goal
Validate a simple KEY=VALUE config file.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi app.conf
vi validate_config.py
python3 validate_config.py
```

## Guided Steps
1. Open `vi app.conf` and add the sample config content below.
2. Open `vi validate_config.py` and add the script content below.
3. Skip blank lines and comments.
4. Split each setting on `=`.
5. Check whether required keys are present.
6. Print a validation result.

## Checkpoint
Why is it helpful to validate config files before a script uses them?

## File Content
`app.conf`
```text
APP_NAME=MyApp
PORT=8080
LOG_LEVEL=INFO
```

## Script Content
```python
required_keys = {'APP_NAME', 'PORT', 'LOG_LEVEL'}
found_keys = set()

with open('app.conf', 'r', encoding='utf-8') as file_handle:
    for line in file_handle:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        key, _ = line.split('=', 1)
        found_keys.add(key)

missing_keys = required_keys - found_keys
if missing_keys:
    print(f'Missing required keys: {sorted(missing_keys)}')
else:
    print('Config valid: True')
```
