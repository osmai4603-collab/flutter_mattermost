# Timezone

Original OpenAPI schema: `Timezone`

No description available in the official OpenAPI schema.

## Fields

- `useAutomaticTimezone`: string
  - Set to "true" to use the browser/system timezone, "false" to set manually. Defaults to "true".
- `manualTimezone`: string
  - Value when setting manually the timezone, i.e. "Europe/Berlin".
- `automaticTimezone`: string
  - This value is set automatically when the "useAutomaticTimezone" is set to "true".

## Example JSON

```json
{"useAutomaticTimezone": ""string"", "manualTimezone": ""string"", "automaticTimezone": ""string""}
```

