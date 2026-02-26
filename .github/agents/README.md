# Agents

This directory stores GitHub Copilot coding agent instruction files.

Each agent is defined as a Markdown (`.md`) file. Place your locally created agent files here to store and share them via GitHub.

## Usage

1. Copy your agent `.md` files into this directory.
2. Commit and push to GitHub as you would any other file.

For more information on creating and using agents, see the [GitHub Copilot documentation](https://docs.github.com/en/copilot/customizing-copilot/reusing-prompts-and-instructions-in-github-copilot#about-copilot-coding-agents).

## Keeping agents in sync across repositories

A GitHub Actions workflow (`.github/workflows/sync-agents.yml`) automatically pushes any changes made to this directory into every repository listed in `.github/sync-agents-targets.txt`.

### One-time setup

1. **Create a Personal Access Token (PAT)**
   - Go to **GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens** (or classic tokens with `repo` scope).
   - Grant the token **Contents: Read and write** permission for every repository you want to sync to.

2. **Add the PAT as a repository secret**
   - In *this* repository go to **Settings → Secrets and variables → Actions → New repository secret**.
   - Name: `SYNC_TOKEN`
   - Value: your PAT from step 1.

3. **List target repositories**
   - Open `.github/sync-agents-targets.txt`.
   - Add one `owner/repo` entry per line for every repository that should receive the agents.

That's it. The next time you push a change to any `.md` file in this directory, the workflow will automatically create a commit in each target repository with the updated agent files.

### Manual sync

You can also trigger a sync at any time without making a code change:

1. Go to **Actions → Sync Agents to Target Repositories**.
2. Click **Run workflow**.
3. Optionally enable **Dry run** to preview what would be committed without actually pushing.
