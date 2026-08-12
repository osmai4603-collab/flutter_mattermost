# UserThread

Original OpenAPI schema: `UserThread`

a thread that user is following

## Fields

- `id`: string
  - ID of the post that is this thread's root
- `reply_count`: integer
  - number of replies in this thread
- `last_reply_at`: integer
  - timestamp of the last post to this thread
- `last_viewed_at`: integer
  - timestamp of the last time the user viewed this thread
- `participants`: array
  - list of users participating in this thread. only includes IDs unless 'extended' was set to 'true'
- `post`: Post

## Example JSON

```json
{"id": ""string"", "reply_count": 0, "last_reply_at": 0, "last_viewed_at": 0, "participants": [], "post": "Post"}
```
