---
name: validate-unity
description: Validate Unity Editor state after implementation. Guides compilation check, Play Mode testing, MCP inspection, regression check, and performance sanity. Use after start-implementation completes. Routes to fix-unity-error on failure, modular-commits on success.
---

# Skill: validate-unity

## Purpose
Verify implementation correctness before committing.
This skill assesses — it never commits.

## Mandatory Checks

### 1. Compilation
- Confirm Unity reports 0 compile errors
- If errors found → immediately route to `fix-unity-error`
- If warnings found → document and assess severity

### 2. Play Mode Functional Test
Guide the developer to:
- Enter Play Mode
- Reproduce the original scenario from the task
- Test edge cases:
  - Minimum/maximum values
  - Null/empty states
  - Scene reload behavior
  - Multiple rapid inputs (if applicable)

### 3. MCP Editor Inspection
If Unity MCP is active, use it to:
- Inspect the relevant GameObjects
- Verify serialized field values
- Check for missing references (`None (Script)`, `Missing`)
- Confirm hierarchy integrity

### 4. Regression Check
- List adjacent systems that could have been affected
- Ask developer to test each one
- Flag any unexpected behavior

### 5. Performance Sanity
- Open Profiler, record 3–5 seconds in Play Mode
- Flag GC allocations introduced by the change
- Flag unexpected CPU spikes

## Output Format

```markdown
## Validation Report

### Compilation
Status: ✅ Clean / ⚠️ Warnings / ❌ Errors
Details: <list>

### Functional Test
Scenario: <what was tested>
Result: ✅ Pass / ❌ Fail
Edge cases: <list>

### MCP Inspection
Objects: <list>
Serialized values: ✅ Correct / ⚠️ Unexpected
Missing refs: ✅ None / ❌ <list>

### Regression
Systems tested: <list>
Result: ✅ Clean / ⚠️ Minor / ❌ Regression

### Performance
Result: ✅ Clean / ⚠️ Minor spike / ❌ Issue

### Verdict
- [ ] ✅ PASS — routing to modular-commits
- [ ] ❌ FAIL — routing to fix-unity-error
```

## Hard Rules
- ❌ Do NOT commit even if validation passes
- ❌ Do NOT push
- ✅ Always produce the full validation report
- ✅ Route to `fix-unity-error` on any failure
- ✅ Route to `modular-commits` on pass
