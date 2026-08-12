# Executes an inplace upgrade from Team Edition to Enterprise Edition

Original OpenAPI operationId: `UpgradeToEnterprise`
- Method: `POST`
- Path: `/api/v4/upgrade_to_enterprise`
- Summary: Executes an inplace upgrade from Team Edition to Enterprise Edition
- Description: It downloads the Mattermost Enterprise Edition of your current version and replace your current version with it. After the upgrade you need to restart the Mattermost server.
__Minimum server version__: 5.27
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `202`: Upgrade started
  - `application/json` -> PushNotification
- `403`: No description available.
- `429`: No description available.
