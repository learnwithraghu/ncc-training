# Lab 05 Steps

## Step 1: Inspect running processes
Run:
```bash
ps -ef | grep mock-service
```
Or:
```bash
pgrep -a mock-service
```
Explain that the learner is searching for the training service.

## Step 2: Confirm the process ID
Run:
```bash
cat ~/ncc-labs/day1/process-lab/state/mock-service.pid
```
Compare the saved PID with the process list.

## Step 3: Check the process state
Run:
```bash
ps -p $(cat ~/ncc-labs/day1/process-lab/state/mock-service.pid) -o pid,ppid,stat,cmd
```
Explain the meaning of the process columns.

## Step 4: Stop the process safely
Run:
```bash
kill $(cat ~/ncc-labs/day1/process-lab/state/mock-service.pid)
```
Then confirm it stopped:
```bash
pgrep -a mock-service
```

## Step 5: Start it again if needed
Run:
```bash
nohup ~/ncc-labs/day1/process-lab/bin/mock-service.sh >/dev/null 2>&1 &
echo $! > ~/ncc-labs/day1/process-lab/state/mock-service.pid
```
This recreates the background service.

## Step 6: Verify the final state
Run:
```bash
ps -p $(cat ~/ncc-labs/day1/process-lab/state/mock-service.pid) -o pid,stat,cmd
```
Confirm the service is back in the expected state.

## Checkpoint
The learner should know how to identify and control a basic Linux process.
