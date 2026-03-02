# A9 Template — User Guide

This guide explains how to use and maintain the A9 agent template. It is written for non-technical users and assumes you are working in **Visual Studio Code (VS Code)**. No coding knowledge is required to use the system.

---

## Before You Begin — One-Time Setup

Complete these steps once before using the template for the first time.

### 1. Install VS Code

Download and install VS Code from [https://code.visualstudio.com](https://code.visualstudio.com) if you have not already done so.

### 2. Install the GitHub Copilot Extension

1. Open VS Code.
2. Click the **Extensions** icon in the left-hand sidebar (it looks like four squares).
3. In the search box, type **GitHub Copilot**.
4. Click **Install** on the **GitHub Copilot** extension (published by GitHub).
5. Also install **GitHub Copilot Chat** if it appears as a separate extension.
6. When prompted, sign in to your GitHub account.

### 3. Open the Repository in VS Code

1. Open VS Code.
2. Click **File → Open Folder…** (Windows/Linux) or **File → Open…** (Mac).
3. Navigate to your local copy of the `optima-partners` repository and click **Open**.
   - If you have not cloned the repository yet, press `` Ctrl+` `` (Windows/Linux) or `` Cmd+` `` (Mac) to open the integrated terminal, then run:
     ```
     git clone https://github.com/ijward/optima-partners.git
     cd optima-partners
     ```
   - Then use **File → Open Folder…** to open the cloned folder.

### 4. Open the Copilot Chat Panel

- Press `Ctrl+Alt+I` (Windows/Linux) or `Cmd+Option+I` (Mac), **or**
- Click the **GitHub Copilot Chat** icon in the left-hand sidebar (speech bubble icon).

The Chat panel will open on one side of your screen. This is where you interact with A9 Task Manager.

---

## What Is the A9 Template?

The A9 template is a team of AI assistants (called "agents") that work together to plan, build, test, secure and deploy software projects for you. Each agent has a specific job, and they hand work to each other automatically.

You only ever talk to one agent: **A9 Task Manager**.

---

## How to Start a Project

1. **Open the Copilot Chat panel** in VS Code (press `Ctrl+Alt+I` on Windows/Linux or `Cmd+Option+I` on Mac if it is not already open).

2. **Switch to Agent mode**:
   - At the top of the Chat panel, click the mode dropdown (it may say **Ask** or **Edit**).
   - Select **Agent** from the list.

3. **Select A9 Task Manager as your agent**:
   - Click the **@** button or type `@` in the chat input box.
   - Select **A9 Task Manager** from the list of available agents.
   - If A9 Task Manager does not appear in the list, ensure the `.github/agents/a9-task-manager.md` file exists in the open repository.

4. **Describe what you want** in plain language in the chat input box. For example:
   - *"I want a web page that shows the XML mappings from the xml_mapping repo in a clear diagram."*
   - *"Please validate all XML files in the project against the schema and tell me which ones fail."*
   - *"Review our Databricks notebooks and suggest efficiency improvements."*
   Then press **Enter** or click the send button.

5. **A9 Task Manager will**:
   - Check the learning log for any relevant past experience.
   - Ask A9 Planning Manager to create a plan.
   - Show you the plan and ask for your approval before any work starts.

6. **Review the plan** in the Chat panel and type your response (e.g. *"Yes, proceed"* or *"Please change step 3 to..."*).

7. **Wait for milestone updates.** A9 Task Manager will check in with you at the end of each phase (Planning → Development → Testing → Security → Deployment). You do not need to monitor the work in between. Replies will appear in the Chat panel.

---

## What Happens at Each Phase

| Phase | What happens |
|---|---|
| **Planning** | A9 Planning Manager creates a detailed plan with tasks, owners and timelines |
| **Development** | A9 Developer (and assistants) write the code or configuration |
| **Testing** | A9 Testing Manager runs all tests and confirms everything works |
| **Security** | A9 Security Manager checks for vulnerabilities before anything goes live |
| **Deployment** | A9 Deployment Manager handles two tracks: (1) commits any `.github/*` changes to GitHub, triggering an automatic sync to all your other repos; (2) co-ordinates delivery of the project output — asking whether you want it run locally (creates a Flask app) or hosted on a web server |

---

## Deployment — Local or Hosted?

At the end of every project that produces a web page or visual output, A9 Task Manager will ask you one question:

> *"Should this be run locally (on your own machine) or hosted (on a web server or cloud platform)?"*

### If you choose Local

A9 Deployment Manager will create a small, ready-to-run web server (using **Flask**, a lightweight Python tool) so you can view the output in your browser without any internet hosting. Once it is ready, A9 Task Manager will give you three simple commands to run in the VS Code integrated terminal:

```
cd <project-folder>
pip install -r app/requirements.txt
python app/app.py
```

Then open your browser and go to `http://127.0.0.1:5000`. That's it.

### If you choose Hosted

A9 Task Manager will ask a follow-up question: *"Which platform would you like to host on?"* (for example, GitHub Pages, Azure, AWS). You do not need to know how to set it up — A9 Deployment Manager will co-ordinate the configuration and tell you any remaining steps.

---

## When A9 Task Manager Asks You a Question

Sometimes a sub-agent will hit a decision point and need your input. A9 Task Manager will post the question in the Copilot Chat panel in plain language and wait for your answer before continuing. Simply type your answer in the chat input box and press **Enter**. You never need to speak to the sub-agents directly.

---

## The Learning Log

The system keeps a record of every project called the **learning log** (`a9-learning-log.md`). It records what went well, what went wrong, and recommendations for improvement. Before every new project, A9 Task Manager reads this log to avoid repeating mistakes.

You do not need to update the log yourself. A9 Learning Monitor does this automatically.

---

## Making Changes to the Template

As time goes on, you may want to add new agents, update how existing agents work, or add new skills. Here is how to do each:

### Adding a New Agent

1. Tell A9 Task Manager: *"I need a new agent for [job]."*
2. A9 Task Manager will ask A9 Planning Manager to design the agent.
3. A9 Developer will create the agent file in `.github/agents/`.
4. A9 Deployment Manager will commit the file and sync it to all your repos automatically.

### Updating an Existing Agent

1. Tell A9 Task Manager: *"Please update A9 [name] to [change]."*
2. A9 Developer will update the agent's `.md` file.
3. A9 Deployment Manager will commit and sync the change.

### Adding the Template to a New Repository

**Step 1 — Add the new repository to the sync list (in VS Code):**

1. In VS Code, open the `optima-partners` repository (the central one).
2. In the **Explorer** panel (left sidebar), navigate to `.github/sync-agents-targets.txt`.
3. Click the file to open it.
4. Add a new line at the bottom with the new repository in the format `owner/repo-name` (e.g. `ijward/xml_mapping`).
5. Save the file with `Ctrl+S` (Windows/Linux) or `Cmd+S` (Mac).
6. Open the **Source Control** panel by clicking the branch icon in the left sidebar (or press `Ctrl+Shift+G`).
7. You will see the changed file listed. Click the **+** icon next to the file to stage it.
8. Type a short message in the **Message** box (e.g. `chore: add xml_mapping to sync targets`).
9. Click the **✓ Commit** button, then click **Sync Changes** (or **Push**) to push to GitHub.

**Step 2 — Set up the push-back workflow in the new repository (in VS Code):**

1. Open the new repository in VS Code (**File → Open Folder…**).
2. In the **Explorer** panel, check whether a `.github/workflows/` folder exists. If it does not, you will create it in the next step.
3. Open the integrated terminal with `` Ctrl+` `` (Windows/Linux) or `` Cmd+` `` (Mac).
4. In the terminal, run the following command (adjust the path if your repository structure differs):
   ```
   mkdir -p .github/workflows && cp .github/agents/push-agents-to-central-template.yml .github/workflows/push-agents-to-central.yml
   ```
5. Back in the **Explorer** panel, open the newly created file at `.github/workflows/push-agents-to-central.yml`.
6. Find the line that reads `CENTRAL_REPO: ijward/optima-partners` — confirm it matches this repository's name. No change should be needed.
7. Save, stage, commit and push the file the same way as in Step 1 above.

**Step 3 — Add the sync secret to the new repository (on GitHub.com):**

1. Open a browser and go to the new repository on GitHub.com.
2. Click **Settings → Secrets and variables → Actions → New repository secret**.
3. Name: `SYNC_TOKEN` · Value: your Personal Access Token (see `.github/agents/README.md` for how to create one).
4. Click **Add secret**.

From this point on, any agent file change pushed to `main` in the central repo will automatically be copied to the new repository.

---

## Rules the Template Always Follows

These rules are built into the agents and cannot be overridden by accident:

| Rule | Why |
|---|---|
| **No inline CSS styles in HTML files** | All styling must go in a shared stylesheet so it is easier to maintain and update |
| **No work starts without an approved plan** | Prevents wasted effort on misunderstood requirements |
| **No deployment without testing and security sign-off** | Catches bugs and security issues before they reach your live repositories |
| **All changes go to GitHub via A9 Deployment Manager** | Keeps a full traceable history of every change |
| **The learning log is always reviewed before planning** | Avoids repeating past mistakes |

---

## Available Automation Workflows

The A9 system includes reusable automation workflows that can be deployed to any project. These workflows handle repetitive tasks automatically without human intervention.

### Auto-Commit Workflow

This workflow automatically detects changes in specified directories, creates commits, pull requests, and optionally auto-merges them.

**When to use it:**
- Keep configuration files (`.github/`) synchronized across projects
- Automate infrastructure-as-code updates
- Maintain consistent GitHub Actions and workflows
- Reduce manual commit overhead

**Key features:**
- Runs on a configurable schedule (default: every 2 hours)
- Monitors any specified directory (default: `.github`)
- Creates timestamped branches for traceability
- Auto-merges PRs to streamline the process
- Can be customized per project with variables

**Adding to your projects:**

1. Copy the workflow file to your project:
   ```bash
   mkdir -p .github/workflows
   curl -o .github/workflows/auto-commit.yml \
     https://raw.githubusercontent.com/ijward/optima-partners/main/.github/workflow-templates/auto-commit-github-changes/workflow.yml
   ```

2. Commit and push:
   ```bash
   git add .github/workflows/auto-commit.yml
   git commit -m "chore: add auto-commit workflow"
   git push
   ```

3. Optionally configure variables in **Settings → Secrets and variables → Actions → Variables**:
   - `SCHEDULE_FREQUENCY` — Adjust how often it runs (e.g., `0 */4 * * *` for every 4 hours)
   - `DIRECTORY_TO_MONITOR` — Change monitored directory (default: `.github`)
   - `COMMIT_MESSAGE_PREFIX` — Customize commit message (default: `Update`)

**For detailed instructions, examples, and troubleshooting, see:**
- [Auto-Commit Workflow Documentation](../workflow-templates/auto-commit-github-changes/README.md)

---

## Token Credits

The A9 system is designed to be as efficient as possible with your AI credits. It achieves this by:

- Using small, focused sub-agents instead of one large conversation.
- Passing only the information each agent needs (not the whole project history).
- Breaking development into small tasks so each sub-agent has a narrow context window.

If you notice the system using more credits than expected, tell A9 Task Manager and it will review the plan for efficiency opportunities.

---

## Troubleshooting

| Problem | What to do |
|---|---|
| A9 Task Manager is not responding | In the Chat panel, start a new conversation by clicking the **+** (New Chat) icon and say: *"Resume the [project name] project."* |
| A9 Task Manager does not appear in the `@` agent list | Check that `.github/agents/a9-task-manager.md` exists in your open repository folder. Close and reopen VS Code if the file was recently added. |
| A sub-agent produced incorrect output | In the Chat panel, tell A9 Task Manager what was wrong. It will route a correction back to the relevant agent. |
| The GitHub sync did not run | Open a browser, go to your repository on GitHub.com, and click **Actions → Sync Agents to Target Repositories → Run workflow**. |
| You want to roll back a change | In the Chat panel, tell A9 Task Manager the commit or feature you want to undo. A9 Deployment Manager will handle it. Alternatively, use the VS Code **Source Control** panel (`Ctrl+Shift+G`) to view the commit history. |
| The learning log is out of date | In the Chat panel, tell A9 Task Manager: *"Please ask A9 Learning Monitor to update the learning log."* |
| You cannot see the Source Control panel | Press `Ctrl+Shift+G` (Windows/Linux) or `Cmd+Shift+G` (Mac) to open it. |
| The integrated terminal is not visible | Press `` Ctrl+` `` (Windows/Linux) or `` Cmd+` `` (Mac) to toggle the terminal. |

---

## Quick Reference: Who to Ask

| You want to... | Say to A9 Task Manager... |
|---|---|
| Start a new project | *"I want to [describe goal]."* |
| Check what is happening | *"Give me a status update."* |
| Change the plan | *"Please change [aspect of plan] to [new approach]."* |
| Add a new agent | *"I need a new agent for [job]."* |
| See the learning log | *"Please summarise the learning log."* |
| Deploy a completed piece of work | *"Please deploy [feature name]."* |
| Sync agents to all repos | *"Please trigger a full agent sync."* |
