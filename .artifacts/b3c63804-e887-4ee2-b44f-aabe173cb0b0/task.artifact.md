# Task: Fix StatefulShellBranch Parameterized Route Exception

- [ ] Modify `lib/app/routes/integration_route.dart` to restructure routing.
    - [ ] Wrap `StatefulShellRoute` in a `GoRoute` with path `/:team/integrations`.
    - [ ] Add redirect for the parent route.
    - [ ] Update branches to use relative paths (`incoming`, `outgoing`, etc.).
- [ ] Verify changes.
    - [ ] Run `analyze_file` on `lib/app/routes/integration_route.dart`.
    - [ ] Manually verify navigation if possible (or just confirm code correctness).
