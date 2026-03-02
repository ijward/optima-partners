# A9 New Sub-Agents Implementation Plan

**Plan Created**: March 2, 2026  
**Created By**: A9 Planning Manager  
**Approved By**: [Pending A9 Task Manager Review]  
**Status**: DRAFT

---

## Executive Summary

This plan covers the addition of two new sub-agents to the A9 system:

1. **a9-researcher** — Documentation and web research specialist
2. **a9-quality-assurance** — Multi-model quality validation specialist

Both agents integrate into the existing A9 hierarchical structure and require new skills, MCP integrations, and workflow updates.

---

## PHASE 1: PLANNING

### 1.1 Requirements Analysis

**Assigned to**: A9 Planning Manager  
**Duration**: Session 1

**Tasks**:
- [x] Review existing agent structure and standards
- [x] Identify integration points with current agents
- [x] Define scope boundaries for each new agent
- [x] Map skill and MCP requirements
- [x] Identify workflow modification points

**Deliverables**:
- This implementation plan
- Agent specification documents (drafts)

**Dependencies**: None

**Risks**:
- ⚠️ Scope creep: a9-researcher's "create new skills" authority needs clear boundaries
- ⚠️ Model access: a9-quality-assurance requires access to multiple AI models (API keys/permissions unknown)

---

### 1.2 Technical Design

**Assigned to**: A9 Planning Manager  
**Duration**: Session 1

**Tasks**:
- [ ] Define a9-researcher interaction patterns with all other agents
- [ ] Define a9-quality-assurance integration into testing workflow
- [ ] Specify skill validation workflow for a9-researcher
- [ ] Design multi-model comparison protocol for a9-quality-assurance
- [ ] Map decision authority for conflicting results

**Deliverables**:
- Agent interaction diagram
- Skill creation/validation workflow specification
- Multi-model comparison protocol

**Dependencies**: 1.1 Requirements Analysis

**Risks**:
- ⚠️ Token efficiency: a9-researcher web searches could consume excessive tokens
- ⚠️ Decision loops: a9-quality-assurance escalations to a9-task-manager need clear resolution paths

---

### 1.3 Skills and MCP Identification

**Assigned to**: A9 Planning Manager  
**Duration**: Session 1

**Tasks**:
- [ ] List required skills for a9-researcher
- [ ] List required skills for a9-quality-assurance
- [ ] Identify required MCP servers (web search, documentation access, model switching)
- [ ] Check existing MCP availability in VS Code
- [ ] Document installation requirements for missing MCPs

**Skills/MCPs/Webhooks Needed**:

**For a9-researcher**:
- **MCP**: `@mcp-search` (web search capability) — needs verification if installed
- **MCP**: `fetch_webpage` (already available as deferred tool)
- **Skill**: `.github/skills/research/documentation-search.md` (new)
- **Skill**: `.github/skills/research/skill-validation-protocol.md` (new)
- **Skill**: `.github/skills/research/web-research-guidelines.md` (new)

**For a9-quality-assurance**:
- **MCP**: Model switching capability (requires investigation — may need custom implementation)
- **Skill**: `.github/skills/qa/multi-model-comparison.md` (new)
- **Skill**: `.github/skills/qa/result-validation-protocol.md` (new)
- **Skill**: `.github/skills/qa/escalation-criteria.md` (new)

**Deliverables**:
- Complete skills list with file paths
- MCP installation checklist
- API key requirements list

**Dependencies**: 1.2 Technical Design

**Risks**:
- ⚠️ Model switching MCP may not exist — may require custom development
- ⚠️ Web search MCP configuration requirements unknown

---

## PHASE 2: DEVELOPMENT

### 2.1 Agent File Creation

**Assigned to**: A9 Developer  
**Duration**: Session 2

**Tasks**:
- [ ] Create `.github/agents/a9-researcher.md` following established format
- [ ] Create `.github/agents/a9-quality-assurance.md` following established format
- [ ] Validate markdown formatting (MD032, MD036 compliance)
- [ ] Include all required sections (Role, Working Style, Responsibilities, Interactions, Hierarchy)
- [ ] Define clear reporting relationships to A9 Task Manager

**Deliverables**:
- `.github/agents/a9-researcher.md`
- `.github/agents/a9-quality-assurance.md`

**Dependencies**: 1.2 Technical Design, 1.3 Skills/MCP Identification

**Risks**: None

---

### 2.2 Skill File Creation — a9-researcher

**Assigned to**: A9 Developer  
**Duration**: Session 2

**Tasks**:
- [ ] Create `.github/skills/research/documentation-search.md`
  - Define search strategy (local files → GitHub → web)
  - Specify token budget per search
  - List trusted documentation sources (official docs, GitHub repos, Stack Overflow)
- [ ] Create `.github/skills/research/web-research-guidelines.md`
  - Define when web research is appropriate vs local search
  - Specify source reliability scoring
  - Include token conservation strategies
- [ ] Create `.github/skills/research/skill-validation-protocol.md`
  - Define periodic skill review schedule
  - Specify skill accuracy checks
  - Detail skill update approval workflow (requires A9 Task Manager sign-off)
  - Include skill creation authority boundaries (what can/cannot be created autonomously)
- [ ] Create `.github/skills/research/README.md` (index file)

**Deliverables**:
- 4 skill files in `.github/skills/research/`

**Dependencies**: 1.3 Skills/MCP Identification

**Risks**:
- ⚠️ Skill validation protocol complexity — needs to balance autonomy with oversight

---

### 2.3 Skill File Creation — a9-quality-assurance

**Assigned to**: A9 Developer  
**Duration**: Session 2-3

**Tasks**:
- [ ] Create `.github/skills/qa/multi-model-comparison.md`
  - Define model selection strategy (primary vs alternate)
  - Specify comparison criteria (exact match, semantic equivalence, acceptable variance)
  - Detail output format for comparison results
- [ ] Create `.github/skills/qa/result-validation-protocol.md`
  - Define when QA check is required (always? sample-based? on request?)
  - Specify validation pass/fail criteria
  - Include handling of edge cases (models disagree on acceptable answer)
- [ ] Create `.github/skills/qa/escalation-criteria.md`
  - Define thresholds for escalation to A9 Task Manager
  - Specify information required in escalation report
  - Detail decision authority flow
- [ ] Create `.github/skills/qa/README.md` (index file)

**Deliverables**:
- 4 skill files in `.github/skills/qa/`

**Dependencies**: 1.3 Skills/MCP Identification

**Risks**:
- ⚠️ Model comparison logic may be complex — need clear criteria to avoid false positives

---

### 2.4 MCP Integration Investigation

**Assigned to**: A9 Developer  
**Duration**: Session 3

**Tasks**:
- [ ] Check if web search MCP is installed in VS Code
- [ ] Test `fetch_webpage` deferred tool availability
- [ ] Research model-switching MCP availability
  - If not available, design custom solution or workaround
  - Document manual model switching instructions for a9-quality-assurance
- [ ] Document API key requirements for web search (if needed)
- [ ] Create installation guide for missing MCPs

**Deliverables**:
- MCP availability report
- Installation instructions (if required)
- Workaround documentation (if MCPs unavailable)

**Dependencies**: 1.3 Skills/MCP Identification

**Risks**:
- ⚠️ **HIGH RISK**: Model-switching MCP may not exist; may need manual workaround
- ⚠️ **MEDIUM RISK**: API key procurement could delay deployment

---

### 2.5 Workflow File Updates

**Assigned to**: A9 Developer  
**Duration**: Session 3

**Tasks**:
- [ ] Review `.github/workflows/sync-agents.yml` — no changes needed (auto-syncs new agent files)
- [ ] Update `.github/SYNC_CONFIG.md` to mention new agents in documentation
- [ ] Update `.github/agents/README.md` to include a9-researcher and a9-quality-assurance

**Deliverables**:
- Updated README files
- Updated SYNC_CONFIG.md

**Dependencies**: 2.1 Agent File Creation

**Risks**: None

---

### 2.6 Documentation Updates

**Assigned to**: A9 Developer  
**Duration**: Session 3

**Tasks**:
- [ ] Update `A9_TEMPLATE_GUIDE.md` to include new agents in agent list
- [ ] Add usage guidance for when to request a9-researcher
- [ ] Add usage guidance for when a9-quality-assurance will be invoked
- [ ] Update agent hierarchy diagram (if present)
- [ ] Update `a9-task-manager.md` to include new agents in "Sub-Agents You Manage" table

**Deliverables**:
- Updated user-facing documentation
- Updated a9-task-manager.md

**Dependencies**: 2.1 Agent File Creation

**Risks**: None

---

## PHASE 3: TESTING

### 3.1 Agent File Validation

**Assigned to**: A9 Testing Manager  
**Duration**: Session 4

**Tasks**:
- [ ] Verify both agent files appear in VS Code `@` agent list
- [ ] Validate markdown formatting (no MD032, MD036 violations)
- [ ] Confirm YAML frontmatter is correct (```chatagent format)
- [ ] Check all links in agent files resolve correctly
- [ ] Validate skill file references are accurate

**Deliverables**:
- Validation report (pass/fail)

**Dependencies**: 2.1 Agent File Creation, 2.2 Skill Creation, 2.3 Skill Creation

**Risks**: None

---

### 3.2 a9-researcher Functional Testing

**Assigned to**: A9 Testing Manager  
**Duration**: Session 4

**Tasks**:
- [ ] Test Case 1: Request a9-researcher to find official documentation for a known technology (e.g., Python `asyncio`)
- [ ] Test Case 2: Request a9-researcher to investigate a vendor API issue (mock scenario)
- [ ] Test Case 3: Request a9-researcher to verify an existing skill's accuracy
- [ ] Verify a9-researcher follows token budget constraints
- [ ] Verify a9-researcher escalates skill creation requests appropriately
- [ ] Verify a9-researcher reports back to requesting agent correctly

**Deliverables**:
- Test results for all 3 test cases
- Token usage report
- Escalation flow validation

**Dependencies**: 2.1 Agent File Creation, 2.2 Skill Creation, 2.4 MCP Integration

**Risks**:
- ⚠️ If web search MCP unavailable, test scope may be limited

---

### 3.3 a9-quality-assurance Functional Testing

**Assigned to**: A9 Testing Manager  
**Duration**: Session 5

**Tasks**:
- [ ] Test Case 1: Request a9-quality-assurance to validate a code generation output using alternate model
- [ ] Test Case 2: Simulate result discrepancy and verify escalation to A9 Task Manager
- [ ] Test Case 3: Verify a9-quality-assurance correctly identifies which agent created original output
- [ ] Test model-switching capability (or manual workaround if MCP unavailable)
- [ ] Verify comparison report format matches specification

**Deliverables**:
- Test results for all 3 test cases
- Model-switching validation report
- Escalation flow validation

**Dependencies**: 2.1 Agent File Creation, 2.3 Skill Creation, 2.4 MCP Integration

**Risks**:
- ⚠️ **HIGH RISK**: If model-switching unavailable, test may be limited to manual verification

---

### 3.4 Integration Testing

**Assigned to**: A9 Testing Manager  
**Duration**: Session 5

**Tasks**:
- [ ] Test a9-researcher integration with a9-developer (research request → result → continued development)
- [ ] Test a9-quality-assurance integration with a9-testing-manager (QA check during testing phase)
- [ ] Test a9-researcher periodic skill validation workflow
- [ ] Verify a9-task-manager can correctly assign tasks to both new agents
- [ ] Verify learning log entries are created for both agents after test scenarios

**Deliverables**:
- Integration test report
- Workflow validation confirmation

**Dependencies**: 3.2 Researcher Testing, 3.3 QA Testing

**Risks**: None

---

## PHASE 4: SECURITY

### 4.1 Agent Permission Review

**Assigned to**: A9 Security Manager  
**Duration**: Session 6

**Tasks**:
- [ ] Review a9-researcher's skill-creation authority boundaries
- [ ] Verify a9-researcher cannot autonomously modify production code
- [ ] Verify a9-researcher web search does not expose sensitive data
- [ ] Review a9-quality-assurance's model-switching access (API keys secure?)
- [ ] Confirm both agents cannot bypass A9 Task Manager approval for deployments

**Deliverables**:
- Security review report
- List of security concerns (if any)

**Dependencies**: 2.1 Agent File Creation, 2.2 Skill Creation, 2.3 Skill Creation

**Risks**:
- ⚠️ a9-researcher skill creation could introduce vulnerabilities if not properly scoped

---

### 4.2 Data Handling Review

**Assigned to**: A9 Security Manager  
**Duration**: Session 6

**Tasks**:
- [ ] Verify a9-researcher does not log API keys or credentials during web searches
- [ ] Check a9-quality-assurance comparison reports do not leak sensitive data
- [ ] Review skill files for hardcoded secrets or credentials
- [ ] Validate all external MCP connections use secure protocols

**Deliverables**:
- Data handling compliance report

**Dependencies**: 2.4 MCP Integration

**Risks**: None

---

### 4.3 Sync Configuration Validation

**Assigned to**: A9 Security Manager  
**Duration**: Session 6

**Tasks**:
- [ ] Verify `.github/workflows/sync-agents.yml` will sync new agent files correctly
- [ ] Confirm new skill files will sync to target repos
- [ ] Check that no sensitive test data will be synced
- [ ] Validate sync-agents-targets.txt includes correct repos

**Deliverables**:
- Sync security validation report

**Dependencies**: 2.5 Workflow Updates

**Risks**: None

---

## PHASE 5: DEPLOYMENT

### 5.1 Pre-Deployment Validation

**Assigned to**: A9 Deployment Manager  
**Duration**: Session 7

**Tasks**:
- [ ] Confirm all Phase 3 tests passed
- [ ] Confirm all Phase 4 security reviews passed
- [ ] Verify all files are ready to commit:
  - `.github/agents/a9-researcher.md`
  - `.github/agents/a9-quality-assurance.md`
  - `.github/skills/research/*.md` (4 files)
  - `.github/skills/qa/*.md` (4 files)
  - Updated documentation files
- [ ] Create deployment checklist

**Deliverables**:
- Deployment readiness report
- Complete file manifest

**Dependencies**: Phase 3 (all), Phase 4 (all)

**Risks**: None

---

### 5.2 Branch Creation and Staging

**Assigned to**: A9 Deployment Manager  
**Duration**: Session 7

**Tasks**:
- [ ] Create feature branch: `feature/add-researcher-qa-agents`
- [ ] Stage all new agent files
- [ ] Stage all new skill files
- [ ] Stage all updated documentation files
- [ ] Commit with message: "feat: add a9-researcher and a9-quality-assurance agents"
- [ ] Push branch to remote

**Deliverables**:
- Feature branch ready for review
- Commit SHA for tracking

**Dependencies**: 5.1 Pre-Deployment Validation

**Risks**: None

---

### 5.3 Pull Request and Review

**Assigned to**: A9 Deployment Manager  
**Duration**: Session 7-8

**Tasks**:
- [ ] Create Pull Request from feature branch to `main`
- [ ] Include summary of changes in PR description
- [ ] Tag A9 Task Manager for review approval
- [ ] Address any PR feedback
- [ ] Obtain A9 Task Manager sign-off

**Deliverables**:
- Pull Request URL
- Approval confirmation

**Dependencies**: 5.2 Branch Creation

**Risks**:
- ⚠️ PR review could identify issues requiring rework

---

### 5.4 Merge to Main

**Assigned to**: A9 Deployment Manager  
**Duration**: Session 8

**Tasks**:
- [ ] Merge PR to `main` (after approval)
- [ ] Verify merge success
- [ ] Monitor `sync-agents.yml` workflow execution
- [ ] Confirm agent files synced to target repos:
  - ijward/xml_mapping
  - ijward/FootballTransferNews
- [ ] Verify sync completion (check commits in target repos)

**Deliverables**:
- Merge confirmation
- Sync validation report

**Dependencies**: 5.3 PR Review and Approval

**Risks**:
- ⚠️ Sync workflow failure would require manual intervention

---

### 5.5 Post-Deployment Verification

**Assigned to**: A9 Deployment Manager  
**Duration**: Session 8

**Tasks**:
- [ ] Open VS Code in target repo `xml_mapping` and verify agents appear in `@` list
- [ ] Open VS Code in target repo `FootballTransferNews` and verify agents appear in `@` list
- [ ] Test invoking a9-researcher in a target repo
- [ ] Test invoking a9-quality-assurance in a target repo
- [ ] Confirm skill files accessible from target repos

**Deliverables**:
- Post-deployment verification report
- Confirmation of full system availability

**Dependencies**: 5.4 Merge to Main

**Risks**: None

---

### 5.6 Learning Log Update

**Assigned to**: A9 Learning Monitor  
**Duration**: Session 8

**Tasks**:
- [ ] Record implementation successes in `a9-learning-log.md`
- [ ] Document any issues encountered during development/testing
- [ ] Note any deviations from plan and reasons
- [ ] Add recommendations for future agent additions
- [ ] Update log with final deployment timestamp

**Deliverables**:
- Updated `a9-learning-log.md`

**Dependencies**: 5.5 Post-Deployment Verification

**Risks**: None

---

## SUMMARY OF UNKNOWNS AND RISKS

### High-Priority Unknowns

1. **Model-switching MCP availability**: a9-quality-assurance requires ability to switch AI models. This may not be available as an MCP. **Mitigation**: Design manual workaround protocol if automated switching unavailable.

2. **API key access for web search**: a9-researcher may require web search API keys. Current availability unknown. **Mitigation**: Document manual web search instructions as fallback.

3. **a9-researcher skill creation authority scope**: Needs clear boundaries to prevent uncontrolled expansion. **Mitigation**: Define explicit approval workflow in skill validation protocol.

### Medium-Priority Risks

4. **Token budget for a9-researcher**: Web searches and documentation reading could consume excessive tokens. **Mitigation**: Implement strict token budgets in skill files.

5. **Decision loops in a9-quality-assurance**: Escalations to A9 Task Manager need clear resolution paths to avoid stalls. **Mitigation**: Define escalation criteria with decision deadlines.

6. **Sync workflow failure**: If sync fails, manual intervention required. **Mitigation**: Document manual sync procedure.

### Dependencies Summary

```
Phase 1 (Planning) → Phase 2 (Development)
Phase 2 → Phase 3 (Testing)
Phase 3 → Phase 4 (Security)
Phase 4 → Phase 5 (Deployment)

Critical Path:
1.3 Skills/MCP Identification → 2.4 MCP Integration → 3.2/3.3 Testing → 5.4 Deployment
```

---

## ESTIMATED EFFORT

| Phase | Sessions | Notes |
|-------|----------|-------|
| Planning | 1 | Complete (this document) |
| Development | 2-3 | Depends on MCP availability |
| Testing | 2 | May extend if issues found |
| Security | 1 | Straightforward review |
| Deployment | 2 | Includes sync validation |
| **TOTAL** | **8-9 sessions** | Assumes no major blockers |

---

## SIGN-OFF

**A9 Planning Manager**: [Plan Complete - Awaiting Approval]  
**A9 Task Manager**: [Pending Review]  
**User**: [Pending Review]

---

## NEXT STEPS

1. A9 Task Manager reviews this plan
2. User reviews and approves this plan
3. A9 Task Manager assigns Phase 2 (Development) to A9 Developer
4. Work proceeds through phases sequentially

---

**END OF PLAN**
