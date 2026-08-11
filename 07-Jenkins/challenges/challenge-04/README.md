# Challenge 04 - Full Simple PHP Pipeline

Create the final simple Jenkinsfile for a PHP workflow using `app.php` and `test.php`.

## Where the code is

- PHP code: `07-Jenkins/challenges/challenge-04/app.php`
- PHP test: `07-Jenkins/challenges/challenge-04/test.php`
- Jenkinsfile location: create your `Jenkinsfile` in `07-Jenkins/challenges/challenge-04/`

## Expected

1. Create one Pipeline job in Jenkins UI.
2. Point it to the local cloned repo on EC2.
3. Use a Jenkinsfile from the challenge folder in `07-Jenkins/challenges/challenge-04/`.
4. Include build and test stages.
5. Make the test stage check PHP syntax or run the simple PHP test.
6. Place the Jenkinsfile in the same challenge folder.
6. Run the job with **Build Now** and confirm both stages run.
