# Get public file metadata headers

Original OpenAPI operationId: `HeadFilePublic`
- Method: `HEAD`
- Path: `/files/{file_id}/public`
- Summary: Get public file metadata headers
- Description: Performs the same validation checks as getting a public file, but returns headers only.

- Tags: files

## Parameters
- `file_id` (path, required, string) - The ID of the file to get
- `h` (query, required, string) - File hash

## Request body
No request body.

## Responses
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
