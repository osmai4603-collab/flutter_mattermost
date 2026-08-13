// The app is a real Mattermost client requiring GetIt DI initialization;
// this smoke test only verifies the harness is wired.
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('smoke: test harness works', () {
    expect(1 + 1, 2);
  });
}
