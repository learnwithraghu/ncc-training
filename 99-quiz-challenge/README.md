# DevOps Quiz Challenge

A comprehensive, interactive MCQ quiz to test your DevOps knowledge across all 11 bootcamp topics.

## Features

- 🔐 **PIN-Protected Sections** — Each quiz requires a 4-digit PIN to access
- 📚 **11 Tech Sections** — Linux, Bash Scripting, Python, GitHub, Docker, Docker Compose, Jenkins, GitHub Actions, Kubernetes, Helm, Capstone
- 📈 **Progressive Difficulty** — Questions go from Easy → Medium → Hard
- 💻 **Code Examples** — Real code snippets in advanced questions
- 📊 **Detailed Results** — See all answers with right/wrong indicators after completion

## 🔑 Quiz PINs

Each section is locked and requires a PIN to access:

| Section | PIN |
|---------|-----|
| Linux Commands | **1847** |
| Bash Scripting | **2935** |
| Python | **3141** |
| GitHub | **3621** |
| Docker | **6389** |
| Docker Compose | **7294** |
| Jenkins | **5274** |
| GitHub Actions | **8462** |
| Kubernetes | **7046** |
| Helm | **9153** |
| Capstone | **1029** |

> ⚠️ **For Instructors:** PINs are stored in `script.js` in the `quizAccessCodes` object. Change them before sharing with students!

## How to Play

1. Select a quiz section from the left sidebar
2. Enter the 4-digit access code to unlock
3. Answer 15 questions (difficulty increases as you progress)
4. Get instant feedback after each question
5. See your final score, rank, and detailed results at the end!

## Running Locally

Simply open `index.html` in your browser.

## Running with Docker

### Build the Image
```bash
docker build -t devops-quiz .
```

### Run the Quiz (Detached mode)
```bash
docker run -d -p 8080:80 --name devops-quiz devops-quiz
```

Then open your browser to [http://localhost:8080](http://localhost:8080).

### Stop the Quiz
```bash
docker stop devops-quiz
docker rm devops-quiz
```

### Full Cleanup & Rebuild
```bash
docker stop devops-quiz 2>/dev/null
docker rm devops-quiz 2>/dev/null
docker rmi devops-quiz 2>/dev/null
docker build -t devops-quiz .
docker run -d -p 8080:80 --name devops-quiz devops-quiz
```

## Question Difficulty Levels

Each section follows this structure:
- **Questions 1-5**: Easy (basic concepts)
- **Questions 6-10**: Medium (practical usage)
- **Questions 11-15**: Hard (advanced, includes code examples)

## Customization

### Changing Access Codes
Edit `script.js` and modify the `quizAccessCodes` object:
```javascript
const quizAccessCodes = {
    linux: '1847',
    bash: '2935',
    python: '3141',
    github: '3621',
    docker: '6389',
    compose: '7294',
    jenkins: '5274',
    actions: '8462',
    k8s: '7046',
    helm: '9153',
    capstone: '1029'
};
```

### Adding/Modifying Questions
Questions are stored in arrays in `script.js` (e.g., `linuxQuestions`, `dockerQuestions`). Each question follows this format:
```javascript
{
    question: "Your question text?",
    options: ["Option A", "Option B", "Option C", "Option D"],
    correct: 0,  // Index of correct answer (0-3)
    explanation: "Explanation shown after answering.",
    code: "optional code block"  // For code example questions
}
```
