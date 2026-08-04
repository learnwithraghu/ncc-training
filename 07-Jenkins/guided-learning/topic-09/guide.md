# Topic 9: General Jenkins Plugin Installation

Plugins add capabilities to Jenkins. This lesson shows how to find, install, update, and verify plugins through the Jenkins web interface.

## Learning Objectives

- Find plugins in the Jenkins plugin manager
- Install a plugin safely
- Verify plugin status and versions
- Understand why plugins should be kept focused and current

## Prerequisites

- Jenkins is running and accessible
- Administrator access to Jenkins

## Step 1: Open the Plugin Manager

1. Open **Manage Jenkins**.
2. Select **Plugins** or **Manage Plugins**, depending on the Jenkins version.
3. Use the **Available plugins** tab to search for plugins.

## Step 2: Install a Plugin

Search for **Pipeline: Input Step**. Select it, then click **Install** or **Install without restart**.

The plugin provides the `input` step used in Topic 8. Jenkins may restart automatically or request a restart after installation.

## Step 3: Verify Installed Plugins

1. Return to the plugin manager.
2. Open the **Installed plugins** tab.
3. Search for `Pipeline: Input Step`.
4. Confirm that it is enabled and has a version listed.

Useful module plugins include:

- **Git** for source checkout
- **Pipeline** for Jenkinsfiles
- **Pipeline: Input Step** for interactive decisions
- **Docker Pipeline** for Docker-aware pipeline steps
- **Gitea** for Gitea integration

## Step 4: Review Updates Carefully

The **Updates** tab lists available updates. Read the dependency information before updating plugins. Apply updates during a maintenance window when Jenkins is shared.

## Checkpoint

> Why should a team install only the plugins it needs instead of installing every available plugin?

## Common Issues

### Plugin Installation Fails

- Check that Jenkins can reach its update site.
- Read the displayed dependency or compatibility error.
- Retry after resolving the dependency issue.

### The Plugin Does Not Appear

- Refresh the plugin manager.
- Check the **Installed plugins** tab.
- Restart Jenkins if the plugin is waiting for a restart.

## Key Takeaways

- Jenkins functionality is extended through plugins.
- Plugin dependencies and Jenkins compatibility matter.
- Always verify that a plugin is installed and enabled before using its steps.

## Next Steps

[Lesson 10: Docker Pipeline Plugin](../topic-10/guide.md) prepares Jenkins for a local Docker image build.
