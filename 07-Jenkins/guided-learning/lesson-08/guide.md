# Lesson 08 - Parameters and Workspace Notes

Add a simple parameter and use workspace files during the build.

## Learn

- Create a string parameter
- Print the parameter value
- Write a small file in the workspace

## Practice

```groovy
parameters {
  string(name: 'APP_NAME', defaultValue: 'python-app')
}
```

```bash
echo "$APP_NAME" > build-name.txt
cat build-name.txt
```

## Checkpoint

Why is a parameter useful when multiple students run the same job?
