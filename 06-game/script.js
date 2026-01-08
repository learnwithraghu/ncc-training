const linuxQuestions = [
    // 5 Easy Questions
    {
        question: "1. Which command lists all files in the current directory?",
        options: ["ls", "list", "show", "dir"],
        correct: 0,
        explanation: "'ls' stands for 'list' and is the standard command to view directory contents."
    },
    {
        question: "2. How do you print the current working directory?",
        options: ["curr", "pwd", "whereami", "cwd"],
        correct: 1,
        explanation: "'pwd' stands for 'Print Working Directory'."
    },
    {
        question: "3. Which command is used to change directories?",
        options: ["move", "goto", "cd", "switch"],
        correct: 2,
        explanation: "'cd' stands for 'Change Directory'."
    },
    {
        question: "4. What is the superuser commonly called in Linux?",
        options: ["admin", "boss", "manager", "root"],
        correct: 3,
        explanation: "'root' is the username of the system administrator with full privileges."
    },
    {
        question: "5. Which command creates a new directory?",
        options: ["newdir", "mkdir", "create", "mk"],
        correct: 1,
        explanation: "'mkdir' stands for 'make directory'."
    },
    // 5 Medium Questions
    {
        question: "6. Which command is used to view the contents of a file?",
        options: ["write", "cat", "dog", "view"],
        correct: 1,
        explanation: "'cat' (concatenate) is commonly used to dump file contents to the terminal."
    },
    {
        question: "7. How do you check for running processes?",
        options: ["taskmgr", "proc", "ps", "run"],
        correct: 2,
        explanation: "'ps' displays the currently running processes (process status)."
    },
    {
        question: "8. What symbol is used to redirect output to a file, overwriting it?",
        options: [">>", "|", "<", ">"],
        correct: 3,
        explanation: "'>' redirects standard output to a file, overwriting existing content. '>>' appends."
    },
    {
        question: "9. Which command is used to change file permissions?",
        options: ["chown", "chmod", "perm", "allow"],
        correct: 1,
        explanation: "'chmod' (change mode) modifies file access permissions."
    },
    {
        question: "10. Which text editor is a common command-line tool?",
        options: ["Word", "NotePad", "Nano", "TextEdit"],
        correct: 2,
        explanation: "'Nano' (or Vi/Vim) is a standard command-line text editor."
    }
];

const shellQuestions = [
    {
        question: "1. How do you start a shell script?",
        options: ["#!/bin/bash", "// start", "<script>", "echo start"],
        correct: 0,
        explanation: "'#!/bin/bash' (Shebang) tells the system to use bash to execute the script."
    },
    {
        question: "2. How do you define a variable in Bash?",
        options: ["var x = 10", "x := 10", "x=10", "int x = 10"],
        correct: 2,
        explanation: "In Bash, variables are assigned without spaces around the '=' sign (e.g., x=10)."
    },
    {
        question: "3. How do you access a variable's value?",
        options: ["$VAR", "%VAR%", "VAR.value", "&VAR"],
        correct: 0,
        explanation: "The '$' symbol is used to reference a variable's value (e.g., echo $NAME)."
    },
    {
        question: "4. Which loop structure iterates over a list?",
        options: ["loop", "foreach", "repeat", "for"],
        correct: 3,
        explanation: "The 'for' loop is standard in Bash (e.g., 'for i in 1 2 3; do ... done')."
    },
    {
        question: "5. How do you check if a file exists in an 'if' statement?",
        options: ["if [ -f file ]", "if (file.exists)", "if exists(file)", "if [-e file]"],
        correct: 0,
        explanation: "'-f' checks if a file exists and is a regular file. '-e' checks existence only."
    },
    {
        question: "6. What is the correct syntax for an 'if' statement?",
        options: ["if ... fi", "if ... end", "check ... done", "if ... endif"],
        correct: 0,
        explanation: "In Bash, 'if' blocks are closed with 'fi' (if spelled backwards)."
    },
    {
        question: "7. How do you read user input into a variable?",
        options: ["input VAR", "get VAR", "read VAR", "scanf VAR"],
        correct: 2,
        explanation: "'read' command pauses script execution to get input from stdin."
    },
    {
        question: "8. What does '$?' store?",
        options: ["Current PID", "Number of args", "Exit status of last command", "User ID"],
        correct: 2,
        explanation: "'$?' holds the exit code of the last executed command (0 for success)."
    },
    {
        question: "9. How do you create a function in Bash?",
        options: ["function myFunc() { ... }", "def myFunc:", "func myFunc { ... }", "create myFunc"],
        correct: 0,
        explanation: "Standard syntax is 'function_name() { ... }' or 'function function_name { ... }'."
    },
    {
        question: "10. Which operator compares integers for equality?",
        options: ["==", "=", "-eq", "equals"],
        correct: 2,
        explanation: "'-eq' is used for numeric comparison. '==' or '=' is for string comparison."
    }
];

let questions = [];
let currentQuestionIndex = 0;
let score = 0;

const questionEl = document.getElementById('question-text');
const optionsContainer = document.getElementById('options-container');
const feedbackArea = document.getElementById('feedback-area');
const feedbackText = document.getElementById('feedback-text');
const nextBtn = document.getElementById('next-btn');
const scoreTracker = document.getElementById('score-tracker');
const questionTracker = document.getElementById('question-tracker');
const gameContainer = document.getElementById('game-container');
const resultsScreen = document.getElementById('results-screen');
const introScreen = document.getElementById('intro-screen');
const startBtn = document.getElementById('start-btn');
const finalScoreDisplay = document.getElementById('final-score-display');
const rankDisplay = document.getElementById('rank-display');
const restartBtn = document.getElementById('restart-btn');
const modeLinuxBtn = document.getElementById('mode-linux');
const modeShellBtn = document.getElementById('mode-shell');
const gameTitle = document.querySelector('h1');

function getModeFromURL() {
    const params = new URLSearchParams(window.location.search);
    return params.get('mode') || 'linux'; // Default to Linux
}

function initGameMode() {
    const mode = getModeFromURL();

    if (mode === 'shell') {
        questions = shellQuestions;
        modeShellBtn.classList.add('active');
        modeLinuxBtn.classList.remove('active');
        gameTitle.textContent = "Shell Scripting Quiz";
    } else {
        questions = linuxQuestions;
        modeLinuxBtn.classList.add('active');
        modeShellBtn.classList.remove('active');
        gameTitle.textContent = "Linux Commando";
    }
}

function startGame() {
    currentQuestionIndex = 0;
    score = 0;
    introScreen.classList.add('hidden');
    gameContainer.classList.remove('hidden');
    resultsScreen.classList.add('hidden');
    updateStats();
    showQuestion();
}

function showIntro() {
    introScreen.classList.remove('hidden');
    gameContainer.classList.add('hidden');
    resultsScreen.classList.add('hidden');
}

startBtn.onclick = startGame;

function updateStats() {
    scoreTracker.textContent = `Score: ${score}`;
    questionTracker.textContent = `Question: ${currentQuestionIndex + 1}/${questions.length}`;
}

function showQuestion() {
    const q = questions[currentQuestionIndex];
    questionEl.textContent = q.question;
    optionsContainer.innerHTML = '';
    feedbackArea.classList.add('hidden');

    q.options.forEach((opt, index) => {
        const btn = document.createElement('button');
        btn.textContent = opt;
        btn.classList.add('option-btn');
        btn.onclick = () => selectAnswer(index, btn);
        optionsContainer.appendChild(btn);
    });
}

function selectAnswer(selectedIndex, btn) {
    const q = questions[currentQuestionIndex];
    const isCorrect = selectedIndex === q.correct;

    // Disable all buttons
    const allBtns = optionsContainer.querySelectorAll('.option-btn');
    allBtns.forEach(b => b.disabled = true);

    if (isCorrect) {
        btn.classList.add('correct');
        score++;
        feedbackText.textContent = `Correct! ${q.explanation}`;
        feedbackText.style.color = 'var(--success-green)';
    } else {
        btn.classList.add('wrong');
        // Highlight correct answer
        allBtns[q.correct].classList.add('correct');
        feedbackText.textContent = `Wrong! ${q.explanation}`;
        feedbackText.style.color = 'var(--error-red)';
    }

    updateStats();
    feedbackArea.classList.remove('hidden');
}

nextBtn.onclick = () => {
    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length) {
        showQuestion();
        updateStats();
    } else {
        endGame();
    }
};

function endGame() {
    gameContainer.classList.add('hidden');
    resultsScreen.classList.remove('hidden');
    finalScoreDisplay.textContent = score;

    let rank = "Newbie";
    if (score === 10) rank = "Root User (God Mode)";
    else if (score >= 8) rank = "SysAdmin";
    else if (score >= 5) rank = "Power User";
    else rank = "Script Kiddie";

    rankDisplay.textContent = `Rank: ${rank}`;
}

restartBtn.onclick = startGame;

// Initialize
initGameMode();
showIntro();

