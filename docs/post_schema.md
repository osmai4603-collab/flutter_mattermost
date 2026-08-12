# Mattermost Post Schema

Source: https://developers.mattermost.com/api-documentation/#/schemas/Post

## Overview
The Post object represents a message created in a Mattermost channel. It includes the core message data, metadata used for rendering, and optional attachments, reactions, priorities, and acknowledgements.

## Fields

- id: string
  - Unique identifier for the post.

- create_at: integer<int64>
  - The time in milliseconds a post was created.

- update_at: integer<int64>
  - The time in milliseconds a post was last updated.

- delete_at: integer<int64>
  - The time in milliseconds a post was deleted.

- edit_at: integer<int64>
  - The time in milliseconds a post was last edited.

- user_id: string
  - The user who created the post.

- channel_id: string
  - The channel where the post was created.

- root_id: string
  - The root post ID for a reply thread or comment.

- original_id: string
  - Original post ID for edited or transformed posts.

- message: string
  - The textual content of the post.

- type: string
  - Post type, if special formatting or plugin-related message type is used.

- props: object
  - Additional metadata used by the client or plugins.

- hashtag: string
  - Hashtag text associated with the post.

- file_ids: array[string]
  - List of attached file IDs.

- pending_post_id: string
  - Used for posts still being processed or pending upload.

- metadata: object
  - Additional information used to display a post.

  - embeds: array[object]
    - Information about embedded content such as OpenGraph previews, image previews, and attachments.
    - This field is null if the post does not contain embedded content.

  - emojis: array[object]
    - Custom emojis appearing in the post or used in reactions.
    - This field is null if no custom emojis are present.

  - files: array[object]
    - FileInfo objects for any files attached to the post.
    - This field is null if there are no file attachments.

  - images: object
    - Mapping from external image URLs to objects containing the dimensions of the image.
    - This field is null if the post or linked content does not reference external images.

  - reactions: array[object]
    - Reactions made to the post.
    - This field is null if no reactions have been made.

  - priority: object
    - Post priority metadata.
    - This field is null if no priority metadata has been set.

  - acknowledgements: array[object]
    - Any acknowledgements made to the post.

## Example JSON

```json
{
  "id": "string",
  "create_at": 0,
  "update_at": 0,
  "delete_at": 0,
  "edit_at": 0,
  "user_id": "string",
  "channel_id": "string",
  "root_id": "string",
  "original_id": "string",
  "message": "string",
  "type": "string",
  "props": {},
  "hashtag": "string",
  "file_ids": ["string"],
  "pending_post_id": "string",
  "metadata": {
    "embeds": [
      {
        "data": {}
      }
    ],
    "emojis": [
      {}
    ],
    "files": [
      {}
    ],
    "images": {},
    "reactions": [],
    "priority": {},
    "acknowledgements": []
  }
}
```

## Notes
- The schema describes a post as a message object in Mattermost.
- Most timestamp fields are stored in milliseconds.
- Metadata is the main area used for UI rendering and rich content previews.
- The object can contain a mix of message content, file metadata, props, and special functionality such as reactions and acknowledgements.

## Arabic summary
هذا الكائن يمثل رسالة داخل قناة Mattermost. ويحتوي على بيانات أساسية مثل نص الرسالة، صاحب الرسالة، القناة، وأوقات الإنشاء والتحديث. كما يحتوي على حقل metadata لتخزين معلومات إضافية مثل:

- المحتوى المدمج (embeds)
- الرموز المخصصة (emojis)
- الملفات المرفقة (files)
- الصور الخارجية (images)
- التفاعلات (reactions)
- أولوية الرسالة (priority)
- الإقرار أو التأكيدات (acknowledgements)

هذه المعلومات تستعمل غالباً في عرض الرسالة بشكل كامل داخل واجهة المستخدم.
