# Simulate an access control policy decision for an explicit user list

Original OpenAPI operationId: `SimulateAccessControlPolicyForUsers`
- Method: `POST`
- Path: `/api/v4/access_control_policies/cel/simulate_users`
- Summary: Simulate an access control policy decision for an explicit user list
- Description: Runs the dual-lane PDP simulation against a draft (unsaved) access
control policy for an explicit set of users (with optional per-user
session-attribute overrides). The server compiles the draft
in-memory, layers on persisted higher-scoped permission policies,
and returns per-user, per-action ALLOW/DENY decisions plus blame
attribution for any deny.

Backs the picker-driven "Simulate access" UX in the System Console
and Channel Settings so authors can see how a draft interacts with
persisted higher-scoped policies before saving.

Gated by the `PermissionPolicies` feature flag and the Enterprise
Advanced license. Returns 501 (Not Implemented) when either is
missing.

##### Permissions
Must have the `manage_system` permission, OR be a team admin with
`manage_team_access_rules` on the request's `team_id` (when any
provided `channel_id` resolves to a channel in that team), OR be a
channel admin with `manage_channel_access_rules` on the request's
`channel_id`.

- Tags: access control

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> PolicySimulationByUsersParams

## Responses
- `200`: Per-user, per-action simulation results.
  - `application/json` -> PolicySimulationResponse
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
