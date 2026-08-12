# ChecklistItem

Original OpenAPI schema: `ChecklistItem`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - A unique, 26 characters long, alphanumeric identifier for the checklist item.
- `title`: string
  - The title of the checklist item.
- `state`: string
  - The state of the checklist item. An empty string means that the item is not done.
- `state_modified`: integer
  - The timestamp for the latest modification of the item's state, formatted as the number of milliseconds since the Unix epoch. It equals 0 if the item was never modified.
- `assignee_id`: string
  - The identifier of the user that has been assigned to complete this item. If the item has no assignee, this is an empty string.
- `assignee_modified`: integer
  - The timestamp for the latest modification of the item's assignee, formatted as the number of milliseconds since the Unix epoch. It equals 0 if the item never got an assignee.
- `command`: string
  - The slash command associated with this item. If the item has no slash command associated, this is an empty string
- `command_last_run`: integer
  - The timestamp for the latest execution of the item's command, formatted as the number of milliseconds since the Unix epoch. It equals 0 if the command was never executed.
- `description`: string
  - A detailed description of the checklist item, formatted with Markdown.
- `delete_at`: integer
  - The timestamp for the last time the item was skipped, formatted as the number of milliseconds since the Unix epoch. It equals 0 if the item was never skipped.
- `due_date`: integer
  - The timestamp for the due date of the checklist item, formatted as the number of milliseconds since the Unix epoch. It equals 0 if not set. For playbooks, this is a relative timestamp; for runs, this is an absolute timestamp.
- `task_actions`: array
  - An array of all the task actions associated with this task.
- `update_at`: integer
  - The timestamp for when this checklist item was last modified, formatted as the number of milliseconds since the Unix epoch.
- `condition_id`: string
  - The ID of the condition that created this checklist item, if any. Empty string if the item was not created by a condition.
- `condition_action`: string
  - A string that represents the action created as a result of a condition evaluation. Empty string means no action, 'hidden' means the item is hidden due to condition not being met, 'shown_because_modified' means the item is shown despite condition not being met because it was recently modified.
- `condition_reason`: string
  - A string representation of the condition that affects this checklist item. Empty string if no condition is associated with this item.

## Example JSON

```json
{"id": ""string"", "title": ""string"", "state": ""string"", "state_modified": 0, "assignee_id": ""string"", "assignee_modified": 0, "command": ""string"", "command_last_run": 0, "description": ""string"", "delete_at": 0, "due_date": 0, "task_actions": [], "update_at": 0, "condition_id": ""string"", "condition_action": ""string"", "condition_reason": ""string""}
```
