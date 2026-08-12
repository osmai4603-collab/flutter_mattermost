# Implementation Plan - Fix Errors and Critical Warnings

The project has over 3500 analysis issues. This plan focuses on fixing actual errors, critical warnings, and redundant code that clutters the static analysis.

## Proposed Changes

### Core & Infrastructure

#### [MODIFY] [entity.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/core/entities/entity.dart)
- Remove `Entity copyWith();` from the base `Entity` class. This method is too restrictive as it takes no parameters, while sub-classes try to override it with optional named parameters, causing `override_on_non_overriding_member` warnings throughout the project.

### Users Feature

#### [MODIFY] [users_remote_data_source.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/users/data/datasources/users_remote_data_source.dart)
- **Error Fix**: Remove the internal SDK import `import 'dart:typed_data';` which is likely a result of an IDE auto-import bug and will cause compilation issues in a standard environment.
- **Lint Fix**: Convert multiple `if (variable != null) 'key': variable` map entries to use the new Dart null-aware map element syntax: `'key': ?variable`.

#### [MODIFY] [thread_read_state_model.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/users/data/models/thread_read_state_model.dart)
- Remove `@override` from `toMap()` as it is not defined in the base class.
- Remove `@override` from `copyWith()` after removing it from the base `Entity` class.

### Teams Feature

#### [MODIFY] [team_member_model.dart](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/teams/data/models/team_member_model.dart)
- Remove `@override` from `toMap()` and `copyWith()`.

### Bulk Fixes (via Delegation)

I will use a sub-agent to identify and fix similar `override_on_non_overriding_member` warnings in other entities and models, as there are many files following this pattern.

## User Review Required

> [!IMPORTANT]
> **Field Naming Convention**: There are many `non_constant_identifier_names` warnings (snake_case in entities). I am NOT fixing these in this pass as they might be deliberate to align with API keys. If you want a full camelCase refactor, please let me know.

> [!NOTE]
> **Entity.copyWith**: Removing `copyWith()` from the base `Entity` class is the most surgical way to fix dozens of warnings without changing the logic of the sub-classes.

## Verification Plan

### Automated Tests
- Run `flutter analyze` after changes to verify the number of issues is significantly reduced and that no new errors are introduced.
- Run `flutter pub get` to ensure dependencies are still correct.

### Manual Verification
- Verify that the code compiles and that the `users_remote_data_source.dart` file no longer has the internal import error.
