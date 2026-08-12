# PostMetadata

Original OpenAPI schema: `PostMetadata`

Additional information used to display a post.

## Fields

- `embeds`: array
  - Information about content embedded in the post including OpenGraph previews, image link previews, and message attachments. This field will be null if the post does not contain embedded content.

- `emojis`: array
  - The custom emojis that appear in this point or have been used in reactions to this post. This field will be null if the post does not contain custom emojis.

- `files`: array
  - The FileInfo objects for any files attached to the post. This field will be null if the post does not have any file attachments.

- `images`: object
  - An object mapping the URL of an external image to an object containing the dimensions of that image. This field will be null if the post or its embedded content does not reference any external images.

- `reactions`: array
  - Any reactions made to this point. This field will be null if no reactions have been made to this post.

- `priority`: object
  - Post priority set for this post. This field will be null if no priority metadata has been set.

- `acknowledgements`: array
  - Any acknowledgements made to this point.


## Example JSON

```json
{"embeds": [], "emojis": [], "files": [], "images": {}, "reactions": [], "priority": {}, "acknowledgements": []}
```

