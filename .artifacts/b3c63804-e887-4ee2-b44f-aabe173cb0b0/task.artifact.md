# Task: Fix StatefulShellBranch Parameterized Route Exception

- [x] Modify `lib/app/routes/integration_route.dart` to restructure routing.
    - [x] Wrap `StatefulShellRoute` in a `GoRoute` with path `/:team/integrations`.
    - [x] Add redirect for the parent route.
    - [x] Update branches to use relative paths (`incoming`, `outgoing`, etc.).
- [x] Verify changes.
    - [x] Run `analyze_file` on `lib/app/routes/integration_route.dart`.
    - [ ] Manually verify navigation if possible (or just confirm code correctness).
