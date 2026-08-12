# WebhookOnStatusUpdatePayload

Original OpenAPI schema: `WebhookOnStatusUpdatePayload`

Source: https://developers.mattermost.com/api-documentation/#/schemas/WebhookOnStatusUpdatePayload

## Fields

- `id`: string
  - A unique, 26 characters long, alphanumeric identifier for the playbook run.
- `name`: string
  - The name of the playbook run.
- `summary`: string
  - The summary of the playbook run.
- `is_active`: boolean
  - True if the playbook run is ongoing; false if the playbook run is ended.
- `owner_user_id`: string
  - The identifier of the user that is commanding the playbook run.
- `team_id`: string
  - The identifier of the team where the playbook run's channel is in.
- `channel_id`: string
  - The identifier of the playbook run's channel.
- `create_at`: integer
  - The playbook run creation timestamp, formatted as the number of milliseconds since the Unix epoch.
- `end_at`: integer
  - The playbook run finish timestamp, formatted as the number of milliseconds since the Unix epoch. It equals 0 if the playbook run is not finished.
- `delete_at`: integer
  - The playbook run deletion timestamp, formatted as the number of milliseconds since the Unix epoch. It equals 0 if the playbook run is not deleted.
- `active_stage`: integer
  - Zero-based index of the currently active stage.
- `active_stage_title`: string
  - The title of the currently active stage.
- `post_id`: string
  - If the playbook run was created from a post, this field contains the identifier of such post. If not, this field is empty.
- `playbook_id`: string
  - The identifier of the playbook with from which this playbook run was created.
- `checklists`: array<Checklist>
- `channel_url`: string
  - Absolute URL to the playbook run's channel.
- `details_url`: string
  - Absolute URL to the playbook run's details.

## Example JSON

```json
{
  "id": "string",
  "name": "string",
  "summary": "string",
  "is_active": false,
  "owner_user_id": "string",
  "team_id": "string",
  "channel_id": "string",
  "create_at": 0,
  "end_at": 0,
  "delete_at": 0,
  "active_stage": 0,
  "active_stage_title": "string",
  "post_id": "string",
  "playbook_id": "string",
  "checklists": [
    {
      "id": "string",
      "title": "string",
      "items": [
        {
          "id": "string",
          "title": "string",
          "state": "",
          "state_modified": 0,
          "assignee_id": "string",
          "assignee_modified": 0,
          "command": "string",
          "command_last_run": 0,
          "description": "string",
          "delete_at": 0,
          "due_date": 0,
          "task_actions": [
            {
              "trigger": {},
              "actions": [
                {}
              ]
            }
          ],
          "update_at": 0,
          "condition_id": "string",
          "condition_action": "",
          "condition_reason": "string"
        }
      ]
    }
  ],
  "channel_url": "string",
  "details_url": "string"
}
```
