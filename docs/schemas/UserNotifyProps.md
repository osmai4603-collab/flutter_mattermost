# UserNotifyProps

Original OpenAPI schema: `UserNotifyProps`

No description available in the official OpenAPI schema.

## Fields

- `email`: string
  - Set to "true" to enable email notifications, "false" to disable. Defaults to "true".
- `push`: string
  - Set to "all" to receive push notifications for all activity, "mention" for mentions and direct messages only, and "none" to disable. Defaults to "mention".
- `desktop`: string
  - Set to "all" to receive desktop notifications for all activity, "mention" for mentions and direct messages only, and "none" to disable. Defaults to "all".
- `desktop_sound`: string
  - Set to "true" to enable sound on desktop notifications, "false" to disable. Defaults to "true".
- `mention_keys`: string
  - A comma-separated list of words to count as mentions. Defaults to username and @username.
- `channel`: string
  - Set to "true" to enable channel-wide notifications (@channel, @all, etc.), "false" to disable. Defaults to "true".
- `first_name`: string
  - Set to "true" to enable mentions for first name. Defaults to "true" if a first name is set, "false" otherwise.
- `auto_responder_message`: string
  - The message sent to users when they are auto-responded to. Defaults to "".
- `push_threads`: string
  - Set to "all" to enable mobile push notifications for followed threads and "none" to disable. Defaults to "all".
- `comments`: string
  - Set to "any" to enable notifications for comments to any post you have replied to, "root" for comments on your posts, and "never" to disable. Only affects users with collapsed reply threads disabled. Defaults to "never".
- `desktop_threads`: string
  - Set to "all" to enable desktop notifications for followed threads and "none" to disable. Defaults to "all".
- `email_threads`: string
  - Set to "all" to enable email notifications for followed threads and "none" to disable. Defaults to "all".

## Example JSON

```json
{"email": ""string"", "push": ""string"", "desktop": ""string"", "desktop_sound": ""string"", "mention_keys": ""string"", "channel": ""string"", "first_name": ""string"", "auto_responder_message": ""string"", "push_threads": ""string"", "comments": ""string"", "desktop_threads": ""string"", "email_threads": ""string""}
```

