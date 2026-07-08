// ===== ACCESS CODES =====
const quizAccessCodes = {
    linux: '1847',
    shell: '2935',
    github: '3621',
    aws: '4158',
    jenkins: '5274',
    docker: '6389',
    k8s: '7046'
};

// ===== QUIZ NAMES =====
const quizNames = {
    linux: 'Linux Commands',
    shell: 'Shell Scripting',
    github: 'GitHub',
    aws: 'AWS & Cloud',
    jenkins: 'Jenkins',
    docker: 'Docker',
    k8s: 'Kubernetes'
};

// ===== LINUX QUESTIONS (15) =====
const linuxQuestions = [
    // Easy (1-5)
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
    // Medium (6-10)
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
        question: "10. What does the 'grep' command do?",
        options: ["Delete files", "Search text patterns", "Copy files", "Compress files"],
        correct: 1,
        explanation: "'grep' searches for patterns in text using regular expressions."
    },
    // Hard (11-15)
    {
        question: "11. What does 'chmod 755 file.sh' mean?",
        options: [
            "Owner: rwx, Group: r-x, Others: r-x",
            "Owner: rw-, Group: r--, Others: r--",
            "Owner: rwx, Group: rwx, Others: rwx",
            "Owner: r-x, Group: rwx, Others: r-x"
        ],
        correct: 0,
        explanation: "7=rwx, 5=r-x. Owner gets full permissions, group and others can read and execute."
    },
    {
        question: "12. Which command finds files larger than 100MB in /home?",
        options: [
            "find /home -size +100M",
            "search /home -gt 100MB",
            "locate /home --size 100M",
            "ls -size 100M /home"
        ],
        correct: 0,
        explanation: "'find' with '-size +100M' finds files larger than 100 megabytes."
    },
    {
        question: "13. What does this command do?",
        code: "ps aux | grep nginx | awk '{print $2}' | xargs kill",
        options: [
            "Lists all nginx processes",
            "Kills all nginx processes",
            "Restarts nginx service",
            "Shows nginx memory usage"
        ],
        correct: 1,
        explanation: "This pipe finds nginx processes, extracts PIDs with awk, and kills them with xargs."
    },
    {
        question: "14. What is the purpose of the sticky bit on a directory?",
        options: [
            "Makes the directory read-only",
            "Only the owner can delete files in that directory",
            "Hides the directory from listing",
            "Encrypts the directory contents"
        ],
        correct: 1,
        explanation: "The sticky bit (t) on directories like /tmp prevents users from deleting others' files."
    },
    {
        question: "15. What is the output of this command?",
        code: "echo $((5 + 3 * 2))",
        options: ["16", "11", "13", "10"],
        correct: 1,
        explanation: "Bash follows order of operations: 3*2=6, then 5+6=11."
    }
];

// ===== SHELL SCRIPTING QUESTIONS (15) =====
const shellQuestions = [
    // Easy (1-5)
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
        question: "5. What is the correct syntax for an 'if' statement?",
        options: ["if ... fi", "if ... end", "check ... done", "if ... endif"],
        correct: 0,
        explanation: "In Bash, 'if' blocks are closed with 'fi' (if spelled backwards)."
    },
    // Medium (6-10)
    {
        question: "6. How do you check if a file exists in an 'if' statement?",
        options: ["if [ -f file ]", "if (file.exists)", "if exists(file)", "if [-e file]"],
        correct: 0,
        explanation: "'-f' checks if a file exists and is a regular file. '-e' checks existence only."
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
        question: "9. Which operator compares integers for equality?",
        options: ["==", "=", "-eq", "equals"],
        correct: 2,
        explanation: "'-eq' is used for numeric comparison. '==' or '=' is for string comparison."
    },
    {
        question: "10. What does '$#' represent in a script?",
        options: ["Process ID", "Number of arguments", "Last argument", "Script name"],
        correct: 1,
        explanation: "'$#' contains the count of command-line arguments passed to the script."
    },
    // Hard (11-15)
    {
        question: "11. What does this script output?",
        code: "x=5\necho $((x * 2))",
        options: ["10", "5", "x * 2", "52"],
        correct: 0,
        explanation: "$((...)) performs arithmetic. 5 * 2 = 10."
    },
    {
        question: "12. What is the output?",
        code: "arr=(one two three)\necho ${arr[1]}",
        options: ["one", "two", "three", "0"],
        correct: 1,
        explanation: "Bash arrays are 0-indexed. arr[0]=one, arr[1]=two, arr[2]=three."
    },
    {
        question: "13. What does 'set -e' do in a script?",
        options: [
            "Enables verbose mode",
            "Exits immediately on any error",
            "Exports all variables",
            "Enables debugging"
        ],
        correct: 1,
        explanation: "'set -e' makes the script exit immediately if any command returns non-zero."
    },
    {
        question: "14. What is the difference between '$@' and '$*'?",
        options: [
            "No difference",
            "$@ treats each arg separately, $* treats all as one string",
            "$* is for arrays, $@ is for strings",
            "$@ includes script name, $* doesn't"
        ],
        correct: 1,
        explanation: "'$@' expands to separate quoted strings, '$*' expands to a single string."
    },
    {
        question: "15. What does this function return?",
        code: "myfunc() {\n  local x=10\n  echo $((x + 5))\n}\nresult=$(myfunc)\necho $result",
        options: ["10", "15", "5", "Error"],
        correct: 1,
        explanation: "The function echoes 15 (10+5), which is captured in 'result' via command substitution."
    }
];

// ===== GITHUB QUESTIONS (15) =====
const githubQuestions = [
    // Easy (1-5)
    {
        question: "1. What is Git?",
        options: [
            "A programming language",
            "A distributed version control system",
            "A code editor",
            "A cloud hosting service"
        ],
        correct: 1,
        explanation: "Git is a distributed version control system for tracking changes in source code."
    },
    {
        question: "2. Which command initializes a new Git repository?",
        options: ["git start", "git init", "git create", "git new"],
        correct: 1,
        explanation: "'git init' creates a new Git repository in the current directory."
    },
    {
        question: "3. How do you stage all changes for commit?",
        options: ["git stage .", "git add .", "git commit .", "git push ."],
        correct: 1,
        explanation: "'git add .' stages all modified and new files in the current directory."
    },
    {
        question: "4. What is a Git branch?",
        options: [
            "A backup of your code",
            "A separate line of development",
            "A type of merge conflict",
            "A remote server"
        ],
        correct: 1,
        explanation: "A branch is an independent line of development, allowing parallel work."
    },
    {
        question: "5. Which command creates a new branch?",
        options: ["git branch new-feature", "git create branch", "git new-branch", "git make branch"],
        correct: 0,
        explanation: "'git branch <name>' creates a new branch without switching to it."
    },
    // Medium (6-10)
    {
        question: "6. What is a Pull Request (PR)?",
        options: [
            "Downloading code from remote",
            "A request to merge changes into another branch",
            "Pulling the latest commits",
            "A request to delete a branch"
        ],
        correct: 1,
        explanation: "A PR proposes changes and requests that someone review and merge them."
    },
    {
        question: "7. What does 'git clone' do?",
        options: [
            "Creates a branch",
            "Copies a repository to your local machine",
            "Deletes a repository",
            "Pushes changes to remote"
        ],
        correct: 1,
        explanation: "'git clone' downloads a complete copy of a remote repository."
    },
    {
        question: "8. How do you switch to an existing branch?",
        options: ["git switch main", "git move main", "git go main", "git change main"],
        correct: 0,
        explanation: "'git switch' (or 'git checkout') switches to an existing branch."
    },
    {
        question: "9. What is the purpose of .gitignore?",
        options: [
            "To delete ignored files",
            "To specify files that Git should not track",
            "To hide the .git folder",
            "To ignore merge conflicts"
        ],
        correct: 1,
        explanation: ".gitignore lists patterns for files/directories that Git should not track."
    },
    {
        question: "10. What does 'git fetch' do?",
        options: [
            "Downloads changes but doesn't merge",
            "Pushes local changes",
            "Deletes remote branches",
            "Creates a new remote"
        ],
        correct: 0,
        explanation: "'git fetch' downloads commits from remote without merging into local branches."
    },
    // Hard (11-15)
    {
        question: "11. What is the difference between 'git merge' and 'git rebase'?",
        options: [
            "No difference",
            "Merge creates a merge commit, rebase rewrites history linearly",
            "Rebase is for remote, merge is for local",
            "Merge is faster than rebase"
        ],
        correct: 1,
        explanation: "Merge preserves history with merge commits; rebase creates a linear history."
    },
    {
        question: "12. What does this command do?",
        code: "git reset --hard HEAD~3",
        options: [
            "Deletes the last 3 commits permanently",
            "Moves HEAD back 3 commits, discarding changes",
            "Creates 3 new commits",
            "Reverts the last 3 commits with new commits"
        ],
        correct: 1,
        explanation: "'--hard HEAD~3' moves HEAD back 3 commits and discards all changes."
    },
    {
        question: "13. What is 'git stash' used for?",
        options: [
            "Permanently deleting changes",
            "Temporarily saving uncommitted changes",
            "Creating a new branch",
            "Pushing to remote"
        ],
        correct: 1,
        explanation: "'git stash' saves uncommitted changes so you can work on something else."
    },
    {
        question: "14. What does 'git cherry-pick' do?",
        options: [
            "Deletes a specific commit",
            "Applies a specific commit from another branch",
            "Lists all commits",
            "Reverts a merge"
        ],
        correct: 1,
        explanation: "'cherry-pick' applies changes from a specific commit to your current branch."
    },
    {
        question: "15. What is a Git hook?",
        options: [
            "A merge conflict resolution tool",
            "Scripts that run automatically on Git events",
            "A type of branch",
            "A remote repository connection"
        ],
        correct: 1,
        explanation: "Git hooks are scripts triggered by events like commit, push, or receive."
    }
];

// ===== AWS & CLOUD QUESTIONS (15) =====
const awsQuestions = [
    // Easy (1-5)
    {
        question: "1. What does AWS stand for?",
        options: [
            "Advanced Web Systems",
            "Amazon Web Services",
            "Automated Web Solutions",
            "Application Web Server"
        ],
        correct: 1,
        explanation: "AWS stands for Amazon Web Services, a cloud computing platform."
    },
    {
        question: "2. What is cloud computing?",
        options: [
            "Local server computing",
            "On-demand delivery of IT resources over the internet",
            "Weather prediction software",
            "A type of database"
        ],
        correct: 1,
        explanation: "Cloud computing provides IT resources on-demand via the internet with pay-as-you-go pricing."
    },
    {
        question: "3. What is an EC2 instance?",
        options: [
            "A database service",
            "A virtual server in the cloud",
            "A storage bucket",
            "A network switch"
        ],
        correct: 1,
        explanation: "EC2 (Elastic Compute Cloud) provides resizable virtual servers (instances)."
    },
    {
        question: "4. What is S3 used for?",
        options: [
            "Running containers",
            "Object storage",
            "Email service",
            "Load balancing"
        ],
        correct: 1,
        explanation: "S3 (Simple Storage Service) is object storage for files, backups, and data."
    },
    {
        question: "5. What are the three main cloud service models?",
        options: [
            "IaaS, PaaS, SaaS",
            "AWS, Azure, GCP",
            "Public, Private, Hybrid",
            "CPU, Memory, Storage"
        ],
        correct: 0,
        explanation: "IaaS (Infrastructure), PaaS (Platform), and SaaS (Software) are the three service models."
    },
    // Medium (6-10)
    {
        question: "6. What is an AWS Region?",
        options: [
            "A billing category",
            "A geographic area with multiple data centers",
            "A type of EC2 instance",
            "A security group"
        ],
        correct: 1,
        explanation: "A Region is a physical location with multiple Availability Zones (data centers)."
    },
    {
        question: "7. What is IAM in AWS?",
        options: [
            "Internet Access Manager",
            "Identity and Access Management",
            "Instance Availability Monitor",
            "Integrated Application Module"
        ],
        correct: 1,
        explanation: "IAM manages users, groups, roles, and permissions for AWS resources."
    },
    {
        question: "8. What is a VPC?",
        options: [
            "Very Private Cloud",
            "Virtual Private Cloud",
            "Virtual Processing Center",
            "Verified Public Connection"
        ],
        correct: 1,
        explanation: "VPC (Virtual Private Cloud) is your isolated network within AWS."
    },
    {
        question: "9. What does an Elastic Load Balancer do?",
        options: [
            "Stores data elastically",
            "Distributes traffic across multiple targets",
            "Scales storage automatically",
            "Manages DNS records"
        ],
        correct: 1,
        explanation: "ELB distributes incoming traffic across EC2 instances, containers, or IPs."
    },
    {
        question: "10. What is Lambda used for?",
        options: [
            "Database management",
            "Serverless compute (run code without servers)",
            "CDN distribution",
            "Email notifications"
        ],
        correct: 1,
        explanation: "Lambda runs code in response to events without provisioning servers."
    },
    // Hard (11-15)
    {
        question: "11. What is the difference between Security Groups and NACLs?",
        options: [
            "No difference",
            "SGs are stateful (instance-level), NACLs are stateless (subnet-level)",
            "NACLs are for EC2, SGs are for S3",
            "SGs are free, NACLs are paid"
        ],
        correct: 1,
        explanation: "Security Groups are stateful and apply to instances; NACLs are stateless and apply to subnets."
    },
    {
        question: "12. What is an Auto Scaling Group?",
        options: [
            "Manual instance management",
            "Automatically adjusts EC2 capacity based on demand",
            "A group of S3 buckets",
            "A VPC configuration"
        ],
        correct: 1,
        explanation: "ASG automatically scales EC2 instances up or down based on policies and demand."
    },
    {
        question: "13. What does this IAM policy allow?",
        code: '{\n  "Effect": "Allow",\n  "Action": "s3:GetObject",\n  "Resource": "arn:aws:s3:::my-bucket/*"\n}',
        options: [
            "Delete objects from my-bucket",
            "Read objects from my-bucket",
            "Create new buckets",
            "Full S3 access"
        ],
        correct: 1,
        explanation: "s3:GetObject allows reading/downloading objects from the specified bucket."
    },
    {
        question: "14. What is CloudFormation?",
        options: [
            "A monitoring service",
            "Infrastructure as Code service for provisioning resources",
            "A CDN service",
            "A database service"
        ],
        correct: 1,
        explanation: "CloudFormation uses templates to provision and manage AWS resources as code."
    },
    {
        question: "15. What is the principle of least privilege?",
        options: [
            "Give everyone admin access",
            "Grant only the permissions needed to perform a task",
            "Use the smallest EC2 instance",
            "Minimize cloud spending"
        ],
        correct: 1,
        explanation: "Least privilege means granting only the minimum permissions required for a task."
    }
];

// ===== JENKINS QUESTIONS (15) =====
const jenkinsQuestions = [
    // Easy (1-5)
    {
        question: "1. What is Jenkins?",
        options: [
            "A container runtime",
            "An open-source automation server for CI/CD",
            "A version control system",
            "A cloud provider"
        ],
        correct: 1,
        explanation: "Jenkins is an open-source automation server used for continuous integration and delivery."
    },
    {
        question: "2. What does CI/CD stand for?",
        options: [
            "Code Integration / Code Delivery",
            "Continuous Integration / Continuous Delivery",
            "Container Instance / Container Deploy",
            "Central Infrastructure / Central Database"
        ],
        correct: 1,
        explanation: "CI/CD refers to Continuous Integration and Continuous Delivery/Deployment."
    },
    {
        question: "3. What is a Jenkins Pipeline?",
        options: [
            "A network connection",
            "A suite of plugins",
            "A definition of the entire build process",
            "A type of node"
        ],
        correct: 2,
        explanation: "A Pipeline defines the complete workflow from build to deployment as code."
    },
    {
        question: "4. What is a Jenkins Job?",
        options: [
            "A Jenkins employee",
            "A runnable task in Jenkins",
            "A plugin type",
            "A security role"
        ],
        correct: 1,
        explanation: "A Job (or Project) is a runnable task configured to perform specific actions."
    },
    {
        question: "5. Where is Jenkins configuration typically stored?",
        options: [
            "/var/jenkins",
            "$JENKINS_HOME",
            "/etc/jenkins.conf",
            "~/.jenkins.yaml"
        ],
        correct: 1,
        explanation: "$JENKINS_HOME (default: /var/lib/jenkins) stores all Jenkins configurations and data."
    },
    // Medium (6-10)
    {
        question: "6. What is a Jenkinsfile?",
        options: [
            "A log file",
            "A file defining the pipeline as code",
            "A configuration backup",
            "A plugin manifest"
        ],
        correct: 1,
        explanation: "A Jenkinsfile is a text file containing the Pipeline definition (Pipeline as Code)."
    },
    {
        question: "7. What are Jenkins Agents/Nodes?",
        options: [
            "Admin users",
            "Machines that execute pipeline jobs",
            "Plugin repositories",
            "Build artifacts"
        ],
        correct: 1,
        explanation: "Agents (formerly slaves) are machines that execute jobs delegated by the controller."
    },
    {
        question: "8. What does the 'stages' block contain in a Pipeline?",
        options: [
            "Environment variables",
            "One or more stage definitions",
            "Post-build actions",
            "Credentials"
        ],
        correct: 1,
        explanation: "The 'stages' block contains one or more 'stage' blocks defining pipeline phases."
    },
    {
        question: "9. What triggers a Jenkins build?",
        options: [
            "Only manual trigger",
            "Webhooks, SCM polling, cron, or manual",
            "Only webhooks",
            "Only on server restart"
        ],
        correct: 1,
        explanation: "Builds can be triggered by webhooks, SCM polling, scheduled (cron), or manually."
    },
    {
        question: "10. What is a Jenkins Plugin?",
        options: [
            "A security vulnerability",
            "An extension that adds functionality to Jenkins",
            "A type of Pipeline",
            "A backup tool"
        ],
        correct: 1,
        explanation: "Plugins extend Jenkins capabilities (Git integration, Docker, notifications, etc.)."
    },
    // Hard (11-15)
    {
        question: "11. What does this Jenkinsfile stage do?",
        code: "stage('Build') {\n  steps {\n    sh 'mvn clean package'\n  }\n}",
        options: [
            "Runs tests",
            "Compiles and packages the application with Maven",
            "Deploys to production",
            "Cleans up old builds"
        ],
        correct: 1,
        explanation: "'mvn clean package' cleans previous builds and creates a new package (JAR/WAR)."
    },
    {
        question: "12. What is the purpose of the 'post' block in a Pipeline?",
        options: [
            "Define environment variables",
            "Run actions after stages complete (always, success, failure)",
            "Configure build triggers",
            "Manage credentials"
        ],
        correct: 1,
        explanation: "The 'post' block defines actions to run after pipeline/stage completion."
    },
    {
        question: "13. What is a Shared Library in Jenkins?",
        options: [
            "A public plugin repository",
            "Reusable Pipeline code stored in a Git repo",
            "A backup of Jenkins configs",
            "A credential store"
        ],
        correct: 1,
        explanation: "Shared Libraries allow reusing Pipeline code across multiple projects."
    },
    {
        question: "14. What does 'agent any' mean in a Declarative Pipeline?",
        options: [
            "No agent is used",
            "Run on any available agent",
            "Use a specific agent named 'any'",
            "Agent selection is manual"
        ],
        correct: 1,
        explanation: "'agent any' allows the Pipeline to run on any available agent/node."
    },
    {
        question: "15. How do you use credentials securely in a Pipeline?",
        options: [
            "Hardcode them in the Jenkinsfile",
            "Use withCredentials() block or credentials() helper",
            "Store them in plain text files",
            "Pass them as build parameters"
        ],
        correct: 1,
        explanation: "withCredentials() and credentials() securely inject credentials from Jenkins' store."
    }
];

// ===== DOCKER QUESTIONS (15) =====
const dockerQuestions = [
    // Easy (1-5)
    {
        question: "1. What is Docker?",
        options: [
            "A virtual machine",
            "A platform for containerizing applications",
            "A programming language",
            "A cloud service"
        ],
        correct: 1,
        explanation: "Docker is a platform for building, shipping, and running applications in containers."
    },
    {
        question: "2. What is a Docker container?",
        options: [
            "A type of database",
            "A lightweight, standalone executable package",
            "A virtual machine",
            "A network protocol"
        ],
        correct: 1,
        explanation: "A container is a lightweight, isolated environment that runs an application."
    },
    {
        question: "3. What is a Docker image?",
        options: [
            "A running container",
            "A read-only template for creating containers",
            "A backup file",
            "A log file"
        ],
        correct: 1,
        explanation: "An image is a read-only template with instructions for creating a container."
    },
    {
        question: "4. Which file defines a Docker image?",
        options: ["docker.yml", "container.conf", "Dockerfile", "image.json"],
        correct: 2,
        explanation: "A Dockerfile contains instructions for building a Docker image."
    },
    {
        question: "5. Which command runs a Docker container?",
        options: ["docker start", "docker run", "docker exec", "docker create"],
        correct: 1,
        explanation: "'docker run' creates and starts a new container from an image."
    },
    // Medium (6-10)
    {
        question: "6. What is Docker Hub?",
        options: [
            "A local Docker daemon",
            "A public registry for Docker images",
            "A networking tool",
            "A container orchestrator"
        ],
        correct: 1,
        explanation: "Docker Hub is a cloud registry service for sharing and storing Docker images."
    },
    {
        question: "7. What does 'docker ps' show?",
        options: [
            "All images",
            "Running containers",
            "Docker version",
            "Network configuration"
        ],
        correct: 1,
        explanation: "'docker ps' lists currently running containers. Add '-a' for all containers."
    },
    {
        question: "8. What is a Docker volume?",
        options: [
            "Container memory",
            "Persistent storage for containers",
            "A network bridge",
            "An image layer"
        ],
        correct: 1,
        explanation: "Volumes persist data generated by containers, even after container deletion."
    },
    {
        question: "9. What does 'docker-compose' do?",
        options: [
            "Builds a single image",
            "Defines and runs multi-container applications",
            "Monitors container health",
            "Backs up containers"
        ],
        correct: 1,
        explanation: "Docker Compose uses YAML files to define and manage multi-container apps."
    },
    {
        question: "10. What is the purpose of EXPOSE in a Dockerfile?",
        options: [
            "Opens a firewall port",
            "Documents which port the container listens on",
            "Exposes environment variables",
            "Publishes the container publicly"
        ],
        correct: 1,
        explanation: "EXPOSE documents the port but doesn't publish it. Use -p flag to publish."
    },
    // Hard (11-15)
    {
        question: "11. What does this Dockerfile instruction do?",
        code: "COPY --from=builder /app/build /usr/share/nginx/html",
        options: [
            "Copies from host to container",
            "Multi-stage build: copies from 'builder' stage",
            "Downloads from a URL",
            "Creates a symbolic link"
        ],
        correct: 1,
        explanation: "--from=builder copies artifacts from a previous build stage (multi-stage builds)."
    },
    {
        question: "12. What is the difference between CMD and ENTRYPOINT?",
        options: [
            "No difference",
            "CMD provides defaults (overridable), ENTRYPOINT is the main command",
            "ENTRYPOINT is deprecated",
            "CMD is for Linux, ENTRYPOINT for Windows"
        ],
        correct: 1,
        explanation: "ENTRYPOINT sets the main command; CMD provides default arguments (can be overridden)."
    },
    {
        question: "13. What does this command do?",
        code: "docker run -d -p 8080:80 --name web nginx",
        options: [
            "Runs nginx in foreground on port 80",
            "Runs nginx in background, mapping host 8080 to container 80",
            "Builds an nginx image",
            "Stops the nginx container"
        ],
        correct: 1,
        explanation: "-d runs detached, -p maps ports, --name assigns a name, nginx is the image."
    },
    {
        question: "14. What is a Docker network bridge?",
        options: [
            "A VPN connection",
            "Default network allowing container-to-container communication",
            "An internet gateway",
            "A load balancer"
        ],
        correct: 1,
        explanation: "Bridge is the default network driver enabling communication between containers."
    },
    {
        question: "15. What is the best practice for Dockerfile layer caching?",
        options: [
            "Put frequently changing instructions first",
            "Put rarely changing instructions first (e.g., dependencies before code)",
            "Combine all instructions into one layer",
            "Disable caching entirely"
        ],
        correct: 1,
        explanation: "Order from least to most frequently changing to maximize layer cache reuse."
    }
];

// ===== KUBERNETES QUESTIONS (15) =====
const k8sQuestions = [
    // Easy (1-5)
    {
        question: "1. What is Kubernetes (K8s)?",
        options: [
            "A container runtime",
            "A container orchestration platform",
            "A cloud provider",
            "A CI/CD tool"
        ],
        correct: 1,
        explanation: "Kubernetes orchestrates containerized applications across clusters of machines."
    },
    {
        question: "2. What is a Pod in Kubernetes?",
        options: [
            "A cluster of nodes",
            "The smallest deployable unit (one or more containers)",
            "A network policy",
            "A storage volume"
        ],
        correct: 1,
        explanation: "A Pod is the smallest unit in K8s, containing one or more containers with shared resources."
    },
    {
        question: "3. What is kubectl?",
        options: [
            "A container runtime",
            "The command-line tool for Kubernetes",
            "A monitoring dashboard",
            "A cluster manager"
        ],
        correct: 1,
        explanation: "kubectl is the CLI for running commands against Kubernetes clusters."
    },
    {
        question: "4. What is a Kubernetes Node?",
        options: [
            "A configuration file",
            "A worker machine that runs Pods",
            "A network endpoint",
            "A storage class"
        ],
        correct: 1,
        explanation: "A Node is a worker machine (VM or physical) that runs containerized workloads."
    },
    {
        question: "5. What is a Deployment in Kubernetes?",
        options: [
            "A one-time job",
            "Manages replica sets and pod updates declaratively",
            "A network service",
            "A storage volume"
        ],
        correct: 1,
        explanation: "A Deployment provides declarative updates for Pods and ReplicaSets."
    },
    // Medium (6-10)
    {
        question: "6. What is a Kubernetes Service?",
        options: [
            "A monitoring tool",
            "An abstraction to expose an application running on Pods",
            "A build automation tool",
            "A log aggregator"
        ],
        correct: 1,
        explanation: "A Service exposes Pods with a stable network endpoint and load balancing."
    },
    {
        question: "7. What is a Namespace in Kubernetes?",
        options: [
            "A DNS record",
            "A way to divide cluster resources between users/teams",
            "A type of container",
            "A storage driver"
        ],
        correct: 1,
        explanation: "Namespaces provide virtual clusters for isolating resources within a physical cluster."
    },
    {
        question: "8. What does 'kubectl get pods' do?",
        options: [
            "Creates new pods",
            "Lists all pods in the current namespace",
            "Deletes pods",
            "Describes pod details"
        ],
        correct: 1,
        explanation: "'kubectl get pods' lists pods. Add '-n <namespace>' for a specific namespace."
    },
    {
        question: "9. What is a ConfigMap?",
        options: [
            "A network map",
            "Stores non-sensitive configuration data as key-value pairs",
            "A pod template",
            "A RBAC policy"
        ],
        correct: 1,
        explanation: "ConfigMaps store configuration data separately from container images."
    },
    {
        question: "10. What is a Secret in Kubernetes?",
        options: [
            "A hidden pod",
            "Stores sensitive information (passwords, tokens)",
            "An encrypted network",
            "A private namespace"
        ],
        correct: 1,
        explanation: "Secrets store sensitive data like passwords, OAuth tokens, and SSH keys."
    },
    // Hard (11-15)
    {
        question: "11. What does this YAML define?",
        code: "apiVersion: v1\nkind: Service\nspec:\n  type: LoadBalancer\n  ports:\n  - port: 80",
        options: [
            "A Pod",
            "A LoadBalancer Service on port 80",
            "A Deployment",
            "An Ingress"
        ],
        correct: 1,
        explanation: "This defines a Service of type LoadBalancer exposing port 80."
    },
    {
        question: "12. What is an Ingress in Kubernetes?",
        options: [
            "Internal pod networking",
            "HTTP/HTTPS route management to services",
            "Egress traffic control",
            "A storage class"
        ],
        correct: 1,
        explanation: "Ingress manages external access to services, typically HTTP/HTTPS routing."
    },
    {
        question: "13. What is the difference between a Deployment and a StatefulSet?",
        options: [
            "No difference",
            "StatefulSet provides stable network IDs and persistent storage",
            "Deployment is for databases only",
            "StatefulSet is deprecated"
        ],
        correct: 1,
        explanation: "StatefulSet maintains sticky identity and persistent storage for stateful apps."
    },
    {
        question: "14. What is a DaemonSet used for?",
        options: [
            "Running a single pod",
            "Ensuring a pod runs on all (or some) nodes",
            "Managing deployments",
            "Storing secrets"
        ],
        correct: 1,
        explanation: "DaemonSet ensures a copy of a Pod runs on all (or selected) Nodes."
    },
    {
        question: "15. What is a Horizontal Pod Autoscaler (HPA)?",
        options: [
            "Vertical scaling of nodes",
            "Automatically scales Pods based on CPU/memory or custom metrics",
            "A network load balancer",
            "A multi-cluster federation tool"
        ],
        correct: 1,
        explanation: "HPA automatically scales the number of Pods based on observed metrics."
    }
];

// ===== QUESTION BANK MAPPING =====
const questionBanks = {
    linux: linuxQuestions,
    shell: shellQuestions,
    github: githubQuestions,
    aws: awsQuestions,
    jenkins: jenkinsQuestions,
    docker: dockerQuestions,
    k8s: k8sQuestions
};

// ===== STATE MANAGEMENT =====
let currentMode = null;
let questions = [];
let currentQuestionIndex = 0;
let score = 0;
let userAnswers = [];
let unlockedQuizzes = new Set();

// ===== DOM ELEMENTS =====
const gameTitle = document.getElementById('game-title');
const questionTracker = document.getElementById('question-tracker');
const scoreTracker = document.getElementById('score-tracker');
const introScreen = document.getElementById('intro-screen');
const gameContainer = document.getElementById('game-container');
const resultsScreen = document.getElementById('results-screen');
const questionEl = document.getElementById('question-text');
const codeBlock = document.getElementById('code-block');
const optionsContainer = document.getElementById('options-container');
const feedbackArea = document.getElementById('feedback-area');
const feedbackText = document.getElementById('feedback-text');
const nextBtn = document.getElementById('next-btn');
const finalScoreDisplay = document.getElementById('final-score-display');
const totalQuestionsDisplay = document.getElementById('total-questions');
const rankDisplay = document.getElementById('rank-display');
const resultsDetail = document.getElementById('results-detail');
const restartBtn = document.getElementById('restart-btn');

// Modal elements
const passcodeModal = document.getElementById('passcode-modal');
const modalQuizName = document.getElementById('modal-quiz-name');
const passcodeInput = document.getElementById('passcode-input');
const passcodeError = document.getElementById('passcode-error');
const modalCancel = document.getElementById('modal-cancel');
const modalSubmit = document.getElementById('modal-submit');

// Menu items
const menuItems = document.querySelectorAll('.menu-item');

// ===== MENU & PASSCODE FUNCTIONS =====
let pendingMode = null;

function handleMenuClick(mode) {
    if (unlockedQuizzes.has(mode)) {
        startQuiz(mode);
    } else {
        showPasscodeModal(mode);
    }
}

function showPasscodeModal(mode) {
    pendingMode = mode;
    modalQuizName.textContent = quizNames[mode];
    passcodeInput.value = '';
    passcodeError.classList.add('hidden');
    passcodeInput.classList.remove('error');
    passcodeModal.classList.remove('hidden');
    passcodeInput.focus();
}

function hidePasscodeModal() {
    passcodeModal.classList.add('hidden');
    pendingMode = null;
}

function verifyPasscode() {
    const enteredCode = passcodeInput.value;
    if (enteredCode === quizAccessCodes[pendingMode]) {
        unlockedQuizzes.add(pendingMode);
        updateMenuUnlockStatus();
        hidePasscodeModal();
        startQuiz(pendingMode);
    } else {
        passcodeInput.classList.add('error');
        passcodeError.classList.remove('hidden');
        setTimeout(() => {
            passcodeInput.classList.remove('error');
        }, 300);
    }
}

function updateMenuUnlockStatus() {
    menuItems.forEach(item => {
        const mode = item.dataset.mode;
        const lockIcon = item.querySelector('.lock-icon');
        if (unlockedQuizzes.has(mode)) {
            item.classList.add('unlocked');
            lockIcon.textContent = '✅';
        }
    });
}

function updateActiveMenuItem() {
    menuItems.forEach(item => {
        if (item.dataset.mode === currentMode) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });
}

// ===== QUIZ FUNCTIONS =====
function startQuiz(mode) {
    currentMode = mode;
    questions = questionBanks[mode];
    currentQuestionIndex = 0;
    score = 0;
    userAnswers = new Array(questions.length).fill(null);
    
    gameTitle.textContent = quizNames[mode] + ' Quiz';
    totalQuestionsDisplay.textContent = questions.length;
    
    introScreen.classList.add('hidden');
    resultsScreen.classList.add('hidden');
    gameContainer.classList.remove('hidden');
    
    updateActiveMenuItem();
    updateStats();
    showQuestion();
}

function updateStats() {
    scoreTracker.textContent = `Score: ${score}`;
    questionTracker.textContent = `Question: ${currentQuestionIndex + 1}/${questions.length}`;
}

function showQuestion() {
    const q = questions[currentQuestionIndex];
    questionEl.textContent = q.question;
    
    // Handle code block
    if (q.code) {
        codeBlock.textContent = q.code;
        codeBlock.classList.remove('hidden');
    } else {
        codeBlock.classList.add('hidden');
    }
    
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

    // Store user's answer
    userAnswers[currentQuestionIndex] = {
        selected: selectedIndex,
        correct: isCorrect
    };

    // Disable all buttons
    const allBtns = optionsContainer.querySelectorAll('.option-btn');
    allBtns.forEach(b => b.disabled = true);

    if (isCorrect) {
        btn.classList.add('correct');
        score++;
        feedbackText.textContent = `✅ Correct! ${q.explanation}`;
        feedbackText.style.color = 'var(--success-green)';
    } else {
        btn.classList.add('wrong');
        allBtns[q.correct].classList.add('correct');
        feedbackText.textContent = `❌ Wrong! ${q.explanation}`;
        feedbackText.style.color = 'var(--error-red)';
    }

    updateStats();
    feedbackArea.classList.remove('hidden');
}

function showNextQuestion() {
    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length) {
        showQuestion();
        updateStats();
    } else {
        endGame();
    }
}

function endGame() {
    gameContainer.classList.add('hidden');
    resultsScreen.classList.remove('hidden');
    finalScoreDisplay.textContent = score;

    // Calculate rank
    const percentage = (score / questions.length) * 100;
    let rank = "Beginner";
    if (percentage === 100) rank = "🏆 Master (Perfect Score!)";
    else if (percentage >= 80) rank = "⭐ Expert";
    else if (percentage >= 60) rank = "👍 Proficient";
    else if (percentage >= 40) rank = "📚 Learning";
    else rank = "🌱 Beginner";

    rankDisplay.textContent = `Rank: ${rank}`;

    // Build detailed results
    buildResultsDetail();
}

function buildResultsDetail() {
    resultsDetail.innerHTML = '';
    
    questions.forEach((q, index) => {
        const userAnswer = userAnswers[index];
        const isCorrect = userAnswer && userAnswer.correct;
        
        const item = document.createElement('div');
        item.className = `result-item ${isCorrect ? 'correct' : 'wrong'}`;
        
        const questionText = q.question.replace(/^\d+\.\s*/, ''); // Remove number prefix
        
        let html = `
            <div class="result-question">
                <span class="result-indicator">${isCorrect ? '✅' : '❌'}</span>
                <span>${index + 1}. ${questionText}</span>
            </div>
            <div class="result-answers">
        `;
        
        if (userAnswer && userAnswer.selected !== null) {
            const yourAnswerText = q.options[userAnswer.selected];
            const correctAnswerText = q.options[q.correct];
            
            if (isCorrect) {
                html += `<span class="correct-answer">Your answer: ${yourAnswerText}</span>`;
            } else {
                html += `<span class="your-answer">Your answer: ${yourAnswerText}</span><br>`;
                html += `<span class="correct-answer">Correct answer: ${correctAnswerText}</span>`;
            }
        } else {
            html += `<span class="your-answer">Not answered</span><br>`;
            html += `<span class="correct-answer">Correct answer: ${q.options[q.correct]}</span>`;
        }
        
        html += '</div>';
        item.innerHTML = html;
        resultsDetail.appendChild(item);
    });
}

function restartQuiz() {
    if (currentMode) {
        startQuiz(currentMode);
    } else {
        showIntro();
    }
}

function showIntro() {
    introScreen.classList.remove('hidden');
    gameContainer.classList.add('hidden');
    resultsScreen.classList.add('hidden');
    updateActiveMenuItem();
}

// ===== EVENT LISTENERS =====
menuItems.forEach(item => {
    item.addEventListener('click', () => {
        handleMenuClick(item.dataset.mode);
    });
});

modalCancel.addEventListener('click', hidePasscodeModal);
modalSubmit.addEventListener('click', verifyPasscode);

passcodeInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        verifyPasscode();
    }
});

// Close modal on overlay click
passcodeModal.addEventListener('click', (e) => {
    if (e.target === passcodeModal) {
        hidePasscodeModal();
    }
});

nextBtn.addEventListener('click', showNextQuestion);
restartBtn.addEventListener('click', restartQuiz);

// ===== INITIALIZE =====
showIntro();
