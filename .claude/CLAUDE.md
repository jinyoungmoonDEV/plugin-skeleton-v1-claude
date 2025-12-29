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
