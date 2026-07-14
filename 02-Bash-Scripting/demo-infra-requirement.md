# Demo Infra Requirement

## Infra Needed
- Bash shell (version 4+ recommended)
- Core CLI tools: awk, sed, grep, cut, sort
- Permission to execute shell scripts

## Quick Validation
```bash
bash --version | head -n 1
command -v awk sed grep cut sort
echo 'echo bash-ok' > /tmp/ncc-bash-check.sh && chmod +x /tmp/ncc-bash-check.sh && /tmp/ncc-bash-check.sh
```
