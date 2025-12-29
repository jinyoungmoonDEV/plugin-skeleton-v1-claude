# CloudOps Rules

---

## Language
- English only (code, comments)

---

## Naming Convention

### Case
- Directory/File/Variable/Function: `snake_case`
- Class: `PascalCase`
- Constant: `UPPER_SNAKE_CASE`

### Access Modifier
- File-internal function: `_` prefix
- Class-internal method: `_` prefix

### Verb
- `create_*`: DB persistence
- `make_*`: Query/Map/Dict generation
- `generate_*`: Secret/Token generation
- `get_*`: Single retrieval
- `list_*`: Multiple retrieval

---

## Import Order
1. Python stdlib
2. Third-party (boto3, spaceone)
3. Internal modules
- One blank line between groups
- Same layer import prohibited

---

## Coding Rules
- Modify only requested parts
- Preserve existing format/structure
- No unnecessary refactoring

---

## Best Practices
- Pagination required
- Generator pattern
- Minimize API calls
- No hardcoding
- Use secret_data
- No sensitive info in logs

---

## Workflow

### Execution Rules
- Show task list at start
- Wait for user approval after each task
- "auto" or "continue all": execute remaining tasks automatically
- Final step (all workflows): Validation
  - Error/impact analysis
  - YAML structure check (if applicable)

### Prompt Format
```
[N/M] {completed_task} ✓
Next: {next_task}
(enter/auto/skip/stop)
```

---

### WF1: New Service
1. Connector
2. Manager
3. WF3 (Metadata)
4. WF4 (Metrics) - optional

### WF2: New Resource
1. Identify required modules → user confirm
2. Execute identified modules

### WF3: Metadata (Inventory Collector only)
1. Request target service/resource
2. Create metadata YAML

### WF4: Metrics (Inventory Collector only)
1. Request target service/resource
2. Create metrics YAML
