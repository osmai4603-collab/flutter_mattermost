sealed class ActionsEndPoint {
  ActionsEndPoint._();

  static const String base = '/actions';
  static const String dialogsExecute = '$base/dialogs/execute';
  static const String dialogsLookup = '$base/dialogs/lookup';
  static const String dialogsOpen = '$base/dialogs/open';
  static const String dialogsSubmit = '$base/dialogs/submit';
}
