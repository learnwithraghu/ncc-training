# Lab 04: Search, Redirection, and Log Filtering

## Why this lab
Learners start working like operators: finding the right lines, saving output, and narrowing noisy logs.

## Scenario details
The learner is given a noisy application log with mixed info, warning, and error lines. Their task is to isolate the important messages and save the results for review.

## Lab setup
- A sample application log
- A few noisy text files
- A place to save filtered results

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/log-filtering/output
cat > ~/ncc-labs/day1/log-filtering/app.log <<'EOF'
2026-07-17 10:00:00 INFO service started
2026-07-17 10:01:00 WARN retrying request
2026-07-17 10:02:00 ERROR database unavailable
2026-07-17 10:03:00 INFO request completed
EOF
```

## Success criteria
- Search with `grep`
- Use redirection to save output
- Combine commands with pipes
