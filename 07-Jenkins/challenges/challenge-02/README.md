# Challenge 02 - PHP Syntax Check

Create a very small Jenkinsfile that checks PHP syntax for `app.php`.

## Where the code is

- PHP code: `07-Jenkins/challenges/challenge-02/app.php`
- Jenkinsfile location: create your `Jenkinsfile` in `07-Jenkins/challenges/challenge-02/`

## Expected

1. Use the local repo on the EC2 machine.
2. Create a Pipeline job from Jenkins UI.
3. Add one stage for PHP syntax checking.
4. Use the `app.php` file in the challenge folder.
5. Place the Jenkinsfile in the same challenge folder.
5. Make the build fail if syntax is wrong.
6. Run the job with **Build Now**.
