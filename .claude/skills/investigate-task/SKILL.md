---
name: investigate-task
description: Root cause analysis for any task, bug, or feature request. Proposes exactly 3 approaches (Quick Fix, Optimal Fix, Balanced Fix). Use when starting any new task, when asked to investigate or analyze a problem, or before any implementation begins. Never writes code.
---

# Skill: investigate-task

## Purpose
Thoroughly understand a problem before any solution is attempted.
This skill is **strictly investigative** — no code is written, no files are modified.

## Mandatory Steps

### 1. Understand the Task
- Restate the task in your own words to confirm understanding
- Ask up to 3 clarifying questions if anything is ambiguous
- Identify what is being asked vs. the underlying problem

### 2. Identify Root Cause
- Trace the problem to its source — not just the symptom
- Use MCP Unity tools to inspect Editor state if available
- List every file, component, and system involved

### 3. Map Impact
- List every file that could be affected
- Identify downstream dependencies
- Flag risky areas (shared systems, serialized data, performance-sensitive code)

### 4. Propose Exactly 3 Approaches

#### 🟢 Quick Fix
- Minimum viable change
- May accrue technical debt
- Best when: urgency is high, scope is narrow

#### 🔵 Optimal Fix
- Architecturally sound, clean solution
- May require refactoring
- Best when: time allows and codebase quality matters

#### 🟡 Balanced Fix
- Compromise between speed and quality
- Best when: shipping soon but quality cannot be ignored

### 5. Output Format

```markdown
## Investigation: <task title>

### Root Cause
<clear description>

### Affected Areas
- `File/System` — reason

### 🟢 Quick Fix
- What: <description>
- Risk: low/medium/high
- Debt: none/low/medium/high
- Estimate: <time>

### 🔵 Optimal Fix
- What: <description>
- Risk: low/medium/high
- Debt: none/low/medium/high
- Estimate: <time>

### 🟡 Balanced Fix
- What: <description>
- Risk: low/medium/high
- Debt: none/low/medium/high
- Estimate: <time>

### Recommendation
<which approach and why — awaiting human approval>
```

## Hard Rules
- ❌ Do NOT write any code
- ❌ Do NOT create any branch
- ❌ Do NOT modify any file
- ✅ Always present all 3 approaches
- ✅ Always wait for explicit approval before implementation
