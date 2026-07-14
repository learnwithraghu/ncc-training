# Demo Infra Requirement

## Infra Needed
- Modern web browser
- Optional: Docker for containerized run
- Basic local static file serving capability

## Quick Validation
```bash
command -v python3 && python3 -m http.server --help | head -n 1
docker --version || echo 'docker optional for this module'
ls -1 index.html style.css script.js
```
