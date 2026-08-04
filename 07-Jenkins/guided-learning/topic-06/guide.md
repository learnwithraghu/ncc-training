# Topic 6: Groovy Basics

**Time:** 20 minutes

## Goal

Use Groovy inside a `script` block to add logic to a pipeline.

## Commands to Use

No new terminal commands.

## Guided Steps

1. Create a new pipeline job named `groovy-basics`.
2. Paste a pipeline with `script` blocks that:
   - Define variables with `def`
   - Use `if/else` to check the build number
   - Read the `VERSION` file with `readFile`
3. Run the pipeline and read the output.

## Checkpoint

What is the difference between `def myVar` and `env.BUILD_NUMBER`?

## Next Steps

Continue with [Lesson 7: More Groovy](../../07-jenkins-groovy-part2.md).
