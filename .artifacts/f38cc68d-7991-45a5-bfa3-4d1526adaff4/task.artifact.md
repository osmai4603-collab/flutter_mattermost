# Task: Fix Errors and Critical Warnings

- [x] Core & Infrastructure
    - [x] Remove `copyWith()` from `Entity` class ([entity.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/core/entities/entity.dart))
- [x] Users Feature
    - [x] Fix `users_remote_data_source.dart` ([users_remote_data_source.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/users/data/datasources/users_remote_data_source.dart))
        - [x] Remove internal SDK import
        - [x] Apply null-aware map element syntax (`?`)
    - [x] Fix `thread_read_state_model.dart` ([thread_read_state_model.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/users/data/models/thread_read_state_model.dart))
- [ ] Teams Feature
    - [/] Fix `team_member_model.dart` ([team_member_model.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/teams/data/models/team_member_model.dart))
- [ ] Bulk Fixes
    - [ ] `[ ]` Scan and fix other `override_on_non_overriding_member` warnings via sub-agent
- [ ] Verification
    - [ ] `[ ]` Run `flutter analyze`
