# Topic 7: More Groovy

**Time:** 20 minutes

## Goal

Practice loops, functions, file writes, and conditional stages with Groovy.

## Commands to Use

No new terminal commands.

## Guided Steps

1. Create a new pipeline job named `groovy-advanced`.
2. Paste the pipeline that includes:
   - A loop over a list of tools
   - A function that returns a greeting
   - A `when` expression that runs only after build 1
   - A step that writes `build-info.txt`
3. Run the pipeline twice and watch the conditional stage behavior.
4. Download the archived `build-info.txt`.

## Checkpoint

Why did the conditional stage run on the second build but not the first?

## Next Steps

Continue with [Lesson 8: Gitea Integration](../../08-jenkins-gitea-integration.md).
