# Topic 5: Pipeline Stages

**Time:** 20 minutes

## Goal

Build a multi-stage pipeline that runs a build, runs tests, and archives an artifact.

## Commands to Use

```bash
# These commands run inside Jenkins stages
echo "Build ${BUILD_NUMBER}" > output.txt
grep "Build" output.txt
```

## Guided Steps

1. Create a new pipeline job named `pipeline-stages`.
2. Paste the multi-stage pipeline from the full lesson.
3. Run the pipeline.
4. Check the **Stage View**.
5. Download the archived `output.txt` from the build page.

## Checkpoint

Why is it useful to archive `output.txt` after every build?

## Next Steps

Continue with [Lesson 6: Groovy Basics](../../06-jenkins-groovy-part1.md).
