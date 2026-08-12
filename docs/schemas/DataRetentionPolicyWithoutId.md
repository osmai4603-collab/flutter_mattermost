# DataRetentionPolicyWithoutId

Original OpenAPI schema: `DataRetentionPolicyWithoutId`

No description available in the official OpenAPI schema.

## Fields

- `display_name`: string
  - The display name for this retention policy.
- `post_duration`: integer
  - The number of days a message will be retained before being deleted by this policy. If this value is less than 0, the policy has infinite retention (i.e. messages are never deleted).


## Example JSON

```json
{"display_name": ""string"", "post_duration": 0}
```

