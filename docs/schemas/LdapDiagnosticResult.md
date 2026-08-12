# LdapDiagnosticResult

Original OpenAPI schema: `LdapDiagnosticResult`

No description available in the official OpenAPI schema.

## Fields

- `test_name`: string
  - Name/type of the diagnostic test being performed
- `test_value`: string
  - The actual test value (filter string or attribute name)
- `total_count`: integer
  - Number of entries found by the filter
- `message`: string
  - Optional success/info message
- `error`: string
  - Optional error message if test failed
- `sample_results`: array
  - Array of sample LDAP entries found

## Example JSON

```json
{"test_name": ""string"", "test_value": ""string"", "total_count": 0, "message": ""string"", "error": ""string"", "sample_results": []}
```

