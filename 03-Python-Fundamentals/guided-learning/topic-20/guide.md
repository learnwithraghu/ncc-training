# Topic 20: Python Mini Workflow

**Time:** 20 minutes

## Goal
Put the Python fundamentals together into one short practice workflow.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > mini_python_workflow.py << 'EOF'
from pathlib import Path

base_dir = Path.home() / 'ncc-labs' / 'day1'
summary_file = base_dir / 'python_summary.txt'

lines = [
    'Python Mini Workflow',
    '====================',
    f'Working directory: {base_dir}',
    'Scripts reviewed: hello.py, log_parser.py, run_day1.py'
]

summary_file.write_text('\n'.join(lines) + '\n', encoding='utf-8')
print(summary_file.read_text(encoding='utf-8'))
EOF
python3 mini_python_workflow.py
```

## Guided Steps
1. Build a path with `pathlib`.
2. Write a short summary file.
3. Read the summary back and print it.
4. Explain how this uses several concepts from earlier topics.
5. Review the whole module flow from first script to workflow.

## Checkpoint
Which Python concepts from this module did you use in this final workflow?
