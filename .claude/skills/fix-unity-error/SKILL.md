---
name: fix-unity-error
description: Classify any Unity error (compile, runtime, reference, serialization, import, build, editor, physics) and generate exactly 3 solutions with impact, risk, and affected files for each. Use when Unity reports any error during development. Never applies fixes automatically — always awaits approval.
---

# Skill: fix-unity-error

## Purpose
Receive, classify, analyze, and propose solutions for Unity errors.
This skill is **strictly analytical** — it NEVER applies fixes.

## Step 1: Receive the Error

Collect:
- Full error message
- Stack trace
- File path and line number (if available)
- When it occurs: compile / Play Mode / build / Editor startup

## Step 2: Classify the Error

| Category | Description | Examples |
|---|---|---|
| `COMPILE` | C# compilation failure | Syntax error, missing type, ambiguous reference |
| `RUNTIME` | Error during execution | NullReferenceException, IndexOutOfRange, MissingComponent |
| `REFERENCE` | Broken Unity references | Missing Script, broken GUID, missing prefab |
| `SERIALIZATION` | Data read/write failure | Cannot serialize type, YAML parse error |
| `IMPORT` | Asset pipeline failure | Shader import error, texture compression failure |
| `BUILD` | Build-time error | IL2CPP error, stripping issue, platform incompatibility |
| `EDITOR` | Editor-only failure | Custom Editor crash, EditorWindow error, domain reload issue |
| `PHYSICS` | Physics system error | Invalid mesh collider, non-convex trigger |
| `UNKNOWN` | Unclassified | Investigate further |

## Step 3: Analyze Root Cause

- Identify exactly why this error occurs
- Cross-reference with Unity documentation patterns
- Consider project context
- Identify if this is Unity version-specific

## Step 4: Generate Exactly 3 Solutions

### 🟢 Quick Fix
- Fastest resolution
- May not address root cause
- Acceptable for unblocking development

### 🔵 Optimal Fix
- Addresses root cause completely
- Clean, maintainable
- May require more changes

### 🟡 Balanced Fix
- Resolves reliably with reasonable scope
- Some debt acceptable

## Output Format

```markdown
## Error Analysis

### Raw Error
<full error + stack trace>

### Classification
- Category: <COMPILE / RUNTIME / etc.>
- Severity: Critical / High / Medium / Low
- Scope: isolated / systemic

### Root Cause
<why this error occurs>

### Affected Files
- `Path/To/File.cs` — reason

---

### 🟢 Quick Fix
**What:** <step-by-step description>
**Files:** `File.cs` line X — <change description>
**Impact:** low/medium/high
**Risk:** low/medium/high — <explanation>
**Debt:** none/low/medium/high
**Time:** <estimate>

---

### 🔵 Optimal Fix
**What:** <step-by-step description>
**Files:** `File.cs` line X — <change description>
**Impact:** low/medium/high
**Risk:** low/medium/high — <explanation>
**Debt:** none/low/medium/high
**Time:** <estimate>

---

### 🟡 Balanced Fix
**What:** <step-by-step description>
**Files:** `File.cs` line X — <change description>
**Impact:** low/medium/high
**Risk:** low/medium/high — <explanation>
**Debt:** none/low/medium/high
**Time:** <estimate>

---

### Recommendation
<which solution and why>

⚠️ Awaiting your approval before any changes are made.
```

## Hard Rules
- ❌ NEVER apply any fix without explicit approval
- ❌ NEVER modify any file during analysis
- ❌ NEVER skip presenting all 3 solutions
- ✅ Always classify before proposing
- ✅ Always list every affected file
- ✅ Always end with explicit approval request
