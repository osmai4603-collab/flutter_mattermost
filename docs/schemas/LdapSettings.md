# LdapSettings

Original OpenAPI schema: `LdapSettings`

No description available in the official OpenAPI schema.

## Fields

- `Enable`: boolean
- `EnableSync`: boolean
- `LdapServer`: string
- `LdapPort`: integer
- `ConnectionSecurity`: string
- `BaseDN`: string
- `BindUsername`: string
- `BindPassword`: string
- `MaximumLoginAttempts`: integer
- `UserFilter`: string
- `GroupFilter`: string
- `GuestFilter`: string
- `EnableAdminFilter`: boolean
- `AdminFilter`: string
- `GroupDisplayNameAttribute`: string
- `GroupIdAttribute`: string
- `FirstNameAttribute`: string
- `LastNameAttribute`: string
- `EmailAttribute`: string
- `UsernameAttribute`: string
- `NicknameAttribute`: string
- `IdAttribute`: string
- `PositionAttribute`: string
- `LoginIdAttribute`: string
- `PictureAttribute`: string
- `SyncIntervalMinutes`: integer
- `SkipCertificateVerification`: boolean
- `PublicCertificateFile`: string
- `PrivateKeyFile`: string
- `QueryTimeout`: integer
- `MaxPageSize`: integer
- `LoginFieldName`: string

## Example JSON

```json
{"Enable": False, "EnableSync": False, "LdapServer": ""string"", "LdapPort": 0, "ConnectionSecurity": ""string"", "BaseDN": ""string"", "BindUsername": ""string"", "BindPassword": ""string"", "MaximumLoginAttempts": 0, "UserFilter": ""string"", "GroupFilter": ""string"", "GuestFilter": ""string"", "EnableAdminFilter": False, "AdminFilter": ""string"", "GroupDisplayNameAttribute": ""string"", "GroupIdAttribute": ""string"", "FirstNameAttribute": ""string"", "LastNameAttribute": ""string"", "EmailAttribute": ""string"", "UsernameAttribute": ""string"", "NicknameAttribute": ""string"", "IdAttribute": ""string"", "PositionAttribute": ""string"", "LoginIdAttribute": ""string"", "PictureAttribute": ""string"", "SyncIntervalMinutes": 0, "SkipCertificateVerification": False, "PublicCertificateFile": ""string"", "PrivateKeyFile": ""string"", "QueryTimeout": 0, "MaxPageSize": 0, "LoginFieldName": ""string""}
```

