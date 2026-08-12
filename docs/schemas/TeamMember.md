# TeamMember

Original OpenAPI schema: `TeamMember`

No description available in the official OpenAPI schema.

## Fields

- `team_id`: string
  - The ID of the team this member belongs to.
- `user_id`: string
  - The ID of the user this member relates to.
- `roles`: string
  - The complete list of roles assigned to this team member, as a space-separated list of role names, including any roles granted implicitly through permissions schemes.
- `delete_at`: integer
  - The time in milliseconds that this team member was deleted.
- `scheme_user`: boolean
  - Whether this team member holds the default user role defined by the team's permissions scheme.
- `scheme_admin`: boolean
  - Whether this team member holds the default admin role defined by the team's permissions scheme.
- `explicit_roles`: string
  - The list of roles explicitly assigned to this team member, as a space separated list of role names. This list does *not* include any roles granted implicitly through permissions schemes.

## Example JSON

```json
{"team_id": ""string"", "user_id": ""string"", "roles": ""string"", "delete_at": 0, "scheme_user": False, "scheme_admin": False, "explicit_roles": ""string""}
```

