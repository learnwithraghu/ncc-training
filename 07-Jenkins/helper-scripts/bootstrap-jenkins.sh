#!/usr/bin/env bash
set -euo pipefail

# Full Jenkins bootstrap for Ubuntu.
# - Installs Jenkins
# - Seeds jobs for the guided-learning lessons

JENKINS_PORT="${JENKINS_PORT:-8080}"
JENKINS_USER="${JENKINS_USER:-jenkins}"
JENKINS_GROUP="${JENKINS_GROUP:-jenkins}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASS="${ADMIN_PASS:-admin123}"
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

if [[ ${EUID} -ne 0 ]]; then
  exec sudo -E bash "$0" "$@"
fi

install_pkg_repo() {
  apt-get update -y
  apt-get install -y openjdk-17-jre git python3 wget curl gnupg ca-certificates
  mkdir -p /etc/apt/keyrings
  wget -qO /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
  apt-get update -y
  apt-get install -y jenkins
}

configure_jenkins() {
  systemctl enable jenkins
}

create_job() {
  local job_name="$1"
  local description="$2"
  local xml_body="$3"
  local job_dir="/var/lib/jenkins/jobs/${job_name}"
  mkdir -p "${job_dir}"
  cat >"${job_dir}/config.xml" <<XML
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job">
  <description>${description}</description>
  <keepDependencies>false</keepDependencies>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps">
    <script><![CDATA[
${xml_body}
    ]]></script>
    <sandbox>true</sandbox>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
XML
  chown -R "${JENKINS_USER}:${JENKINS_GROUP}" "${job_dir}"
}

install_pkg_repo
configure_jenkins

mkdir -p /var/lib/jenkins/jobs
chown -R "${JENKINS_USER}:${JENKINS_GROUP}" /var/lib/jenkins/jobs

create_job "lesson-01-ec2-boot-and-clone" "Lesson 01 - EC2 Boot and Repo Clone" "pipeline { agent any; stages { stage('Check Repo') { steps { sh 'test -d /home/ec2-user/ncc-training/07-Jenkins && echo Repo ready' } } } }"
create_job "lesson-02-jenkins-install" "Lesson 02 - Command-Based Jenkins Install" "pipeline { agent any; stages { stage('Install Notes') { steps { sh 'echo Use the bootstrap script to install Jenkins' } } } }"
create_job "lesson-03-first-login" "Lesson 03 - Jenkins Web UI First Steps" "pipeline { agent any; stages { stage('Login Step') { steps { sh 'echo Open Jenkins at http://<EC2-PUBLIC-IP>:${JENKINS_PORT}' } } } }"
create_job "lesson-04-freestyle-hello" "Lesson 04 - Freestyle Hello Job" "node { stage('Hello') { sh 'echo Hello from Freestyle' } }"
create_job "lesson-05-python-syntax" "Lesson 05 - Python Syntax Check" "pipeline { agent any; stages { stage('Syntax') { steps { dir('lab-project/python-app') { sh 'python3 -m py_compile app.py test_app.py' } } } } }"
create_job "lesson-06-python-tests" "Lesson 06 - Python Unit Test Job" "pipeline { agent any; stages { stage('Tests') { steps { dir('lab-project/python-app') { sh 'python3 -m unittest -v' } } } } }"
create_job "lesson-07-simple-pipeline" "Lesson 07 - Simple Pipeline Stages" "pipeline { agent any; stages { stage('Syntax Check') { steps { dir('lab-project/python-app') { sh 'python3 -m py_compile app.py test_app.py' } } } stage('Unit Tests') { steps { dir('lab-project/python-app') { sh 'python3 -m unittest -v' } } } } }"
create_job "lesson-08-parameters" "Lesson 08 - Parameters and Workspace Notes" "pipeline { agent any; parameters { string(name: 'APP_NAME', defaultValue: 'python-app') } stages { stage('Write File') { steps { sh 'echo \$APP_NAME > build-name.txt && cat build-name.txt' } } } }"
create_job "lesson-09-local-repo-pipeline" "Lesson 09 - Local Repo Pipeline Job" "pipeline { agent any; stages { stage('Load Jenkinsfile') { steps { sh 'echo Use Pipeline script from SCM with /home/ec2-user/ncc-training and script path 07-Jenkins/lab-project/Jenkinsfile' } } } }"
create_job "lesson-10-build-now-ci" "Lesson 10 - Build Now CI Flow" "pipeline { agent any; stages { stage('Syntax Check') { steps { dir('lab-project/python-app') { sh 'python3 -m py_compile app.py test_app.py' } } } stage('Unit Tests') { steps { dir('lab-project/python-app') { sh 'python3 -m unittest -v' } } } } }"

systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

for _ in {1..60}; do
  if wget -qO- "http://127.0.0.1:${JENKINS_PORT}/login" >/dev/null 2>&1; then
    break
  fi
  sleep 5
done

echo "Jenkins ready at: http://<EC2-PUBLIC-IP>:${JENKINS_PORT}"
echo "Login: ${ADMIN_USER} / ${ADMIN_PASS}"
echo "Seeded guided-learning jobs: lesson-01 through lesson-10"
