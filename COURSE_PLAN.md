# NCC DevOps Bootcamp — Course Plan & Progress Tracker

> This file tracks the overall course structure and implementation progress. Update it at the end of each working session so the next session can pick up where this one left off.

---

## Course Goal

A 5-day, beginner-friendly DevOps bootcamp where each day has sequential `guide_x.md` files, hands-on labs, and a connected narrative. Each day produces an artifact that the next day consumes.

- **Audience:** Beginners / freshers / bootcamp students
- **Daily duration:** 6 hours
- **Lab model:** Pre-provisioned lab environment; learners clone this repo and run commands shown by the instructor

---

## 5-Day Schedule

| Day | Modules | Artifact carried forward |
|-----|---------|--------------------------|
| **Day 1** | `01-Linux` → `02-Bash-Scripting` → `03-Python-Fundamentals` | `~/ncc-labs/day1/` with `backup.sh` + `log_parser.py` |
| **Day 2** | `04-Git-and-GitHub` | GitHub repo `ncc-labs` hosting Day 1 files |
| **Day 3** | `05-Docker` → `06-Docker-Compose` | Docker image + `docker-compose.yml` for a Python app |
| **Day 4** | `07-Jenkins` → `08-GitHub-Actions` (+ ECR) | CI pipeline pushing the Day 3 image to ECR |
| **Day 5** | `09-Kubernetes` → `10-Helm` → `11-Capstone-Document-Search` | Helm chart deploying the document-search app to K8s |

---

## Module Structure

```
ncc-training/
├── COURSE_PLAN.md                  ← This file
├── 00-course-roadmap.md            # Visual day-by-day learning map
├── 01-Linux/                       # Day 1 — Linux fundamentals
├── 02-Bash-Scripting/              # Day 1 — Bash scripting
├── 03-Python-Fundamentals/         # Day 1 — Python for DevOps
├── 04-Git-and-GitHub/              # Day 2 — Version control & collaboration
├── 05-Docker/                      # Day 3 — Containerization
├── 06-Docker-Compose/              # Day 3 — Multi-container apps
├── 07-Jenkins/                     # Day 4 — CI/CD with Jenkins
├── 08-GitHub-Actions/              # Day 4 — CI/CD with GitHub Actions
├── 09-Kubernetes/                  # Day 5 — Container orchestration
├── 10-Helm/                        # Day 5 — Kubernetes package manager
├── 11-Capstone-Document-Search/    # Day 5 — End-to-end project
└── 99-quiz-challenge/              # MCQ quiz challenge across all topics
```

---

## Implementation Progress

### Phase 1: Foundation restructure
- [x] Create `COURSE_PLAN.md`
- [x] Create `00-course-roadmap.md`
- [x] Restructure existing folders into new module numbering
- [x] Update root `README.md`

### Phase 2: Day 1 content
- [x] `01-Linux/` — map existing files to `guide_x.md` sequence
- [x] `02-Bash-Scripting/` — create guides and labs
- [x] `03-Python-Fundamentals/` — create guides and labs
- [x] Day 1 narrative bridge: scripts feed into Day 2 Git repo

### Phase 3: Missing topic modules
- [x] `04-Git-and-GitHub/` — migrate `02-Git/` content + add GitHub basics
- [x] `06-Docker-Compose/` — create guides and labs
- [x] `08-GitHub-Actions/` — create guides and workflows
- [x] `10-Helm/` — create guides and chart examples

### Phase 4: Capstone placeholders
- [x] `11-Capstone-Document-Search/` — create placeholder guides

### Phase 5: Connectivity & verification
- [x] Add narrative bridges between days
- [ ] Run Day 1 walkthrough
- [ ] Verify file structure and cross-links

---

## Session Notes

### 2026-07-08
- Restructured repo into 11 numbered modules.
- Created Day 1 guides for Linux, Bash Scripting, and Python Fundamentals.
- Created placeholder modules and guides for Days 2–5.
- Updated `README.md`, `00-course-roadmap.md`, and `99-quiz-challenge/README.md`.
- Pushed all changes to GitHub.

---

## Session Notes

### 2026-07-08
- Approved plan: 11 numbered modules, Day 5 capstone, separate modules for missing topics.
- Decided to move existing `02-Git/` content into new `04-Git-and-GitHub/`.
- Decided to use one `00-course-roadmap.md` plus per-module READMEs for daily navigation.
- Capstone app complexity deferred — placeholders only for now.

