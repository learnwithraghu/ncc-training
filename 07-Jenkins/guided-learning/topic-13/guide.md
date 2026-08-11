# Topic 13: Jenkins Credentials Store

**Time:** 20 minutes

## Goal
Store a secret through the Jenkins console's credentials store and use it in a pipeline stage,
without ever writing the secret value into the Jenkinsfile.

## Guided Steps
1. From the Jenkins dashboard, go to **Manage Jenkins -> Credentials -> System -> Global
   credentials (unrestricted) -> Add Credentials**.
2. Set **Kind** to `Secret text`, paste any fake value (e.g. `demo-api-key-12345`) into **Secret**,
   set **ID** to `app-api-key`, and click **Create**.
3. Open `lab-pipeline` -> **Configure** and add a `Use Secret` stage after `Package`:
   ```groovy
        stage('Use Secret') {
            steps {
                withCredentials([string(credentialsId: 'app-api-key', variable: 'APP_API_KEY')]) {
                    sh 'echo "Using API key of length: ${#APP_API_KEY}"'
                }
            }
        }
   ```
   Note this stage is added directly in the console, not baked into the image - credentials are
   environment-specific, so it doesn't belong in a Dockerfile or a committed Jenkinsfile the same
   way plugins and app code do.
4. Save, then **Build Now**.
5. Open **Console Output** and find the `Use Secret` stage. Jenkins prints the secret's length, not
   its value - and if you try to `echo $APP_API_KEY` directly instead, Jenkins masks it as `****`
   in the console log automatically.
6. Go back to **Manage Jenkins -> Credentials** and confirm there's no way to view the secret's
   value again from the UI - only replace it.

## Checkpoint
Why does Jenkins mask the credential's value in console output instead of just printing it, and
why is `withCredentials` safer than putting the secret directly in an `environment { }` block?
