# Playbook

Original OpenAPI schema: `Playbook`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - A unique, 26 characters long, alphanumeric identifier for the playbook.
- `title`: string
  - The title of the playbook.
- `description`: string
  - The description of the playbook.
- `team_id`: string
  - The identifier of the team where the playbook is in.
- `create_public_playbook_run`: boolean
  - A boolean indicating whether the playbook runs created from this playbook should be public or private.
- `create_at`: integer
  - The playbook creation timestamp, formatted as the number of milliseconds since the Unix epoch.
- `delete_at`: integer
  - The playbook deletion timestamp, formatted as the number of milliseconds since the Unix epoch. It equals 0 if the playbook is not deleted.
- `num_stages`: integer
  - The number of stages defined in this playbook.
- `num_steps`: integer
  - The total number of steps from all the stages defined in this playbook.
- `checklists`: array
  - The stages defined in this playbook.
- `member_ids`: array
  - The identifiers of all the users that are members of this playbook.
- `channel_name_template`: string
  - A template used to derive the channel name and the run name/title when a run is created from this playbook. May reference property fields and system tokens such as {SEQ}.
- `channel_name_template_locked`: boolean
  - When true, the channel_name_template always overrides the supplied name when creating a run. When false (the default), the template is only a suggested default and the caller may supply their own name.

## Example JSON

```json
{"id": ""string"", "title": ""string"", "description": ""string"", "team_id": ""string"", "create_public_playbook_run": False, "create_at": 0, "delete_at": 0, "num_stages": 0, "num_steps": 0, "checklists": [], "member_ids": [], "channel_name_template": ""string"", "channel_name_template_locked": False}
```
