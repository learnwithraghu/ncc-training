# Solution: Dockerfile Review

## Example Fix
- Use a smaller base image if appropriate.
- Copy only the files the app needs.
- Keep the build and runtime layers simple.

## Example Commands
```bash
docker build -t ncc-app ./application
```

## Notes
- The exact fix depends on the issue in the sample Dockerfile.
- The instructor can use this file to explain the build steps and the reason for the change.