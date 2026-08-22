sealed class PlaybooksEndPoint {
  PlaybooksEndPoint._();

  static const String base = '/plugins/playbooks/api/v0';
  static const String runs = '$base/runs';
  static const String runDialog = '$base/runs/dialog';
  static const String owners = '$base/owners';
  static const String playbooks = '$base/playbooks';
  static String playbook(String id) => '$base/playbooks/$id';
  static String playbookConditions(String id) => '$base/playbooks/$id/conditions';
  static String playbookCondition(String id, String conditionId) =>
      '$base/playbooks/$id/conditions/$conditionId';
  static String playbookPropertyFields(String id) =>
      '$base/playbooks/$id/property_fields';
  static String playbookPropertyFieldsReorder(String id) =>
      '$base/playbooks/$id/property_fields/reorder';
  static String playbookPropertyField(String id, String fieldId) =>
      '$base/playbooks/$id/property_fields/$fieldId';
  static String playbookAutoFollows(String id) => '$base/playbooks/$id/autofollows';
  static String run(String runId) => '$base/runs/$runId';
  static String runByChannel(String channelId) => '$base/runs/channel/$channelId';
  static String runEnd(String runId) => '$base/runs/$runId/end';
  static String runEndDialog(String runId) => '$base/runs/$runId/end_dialog';
  static String runFinish(String runId) => '$base/runs/$runId/finish';
  static String runMetadata(String runId) => '$base/runs/$runId/metadata';
  static String runNextStageDialog(String runId) => '$base/runs/$runId/next_stage_dialog';
  static String runOwner(String runId) => '$base/runs/$runId/owner';
  static String runRestart(String runId) => '$base/runs/$runId/restart';
  static String runStatus(String runId) => '$base/runs/$runId/status';
  static String runConditions(String runId) => '$base/runs/$runId/conditions';
  static String runChecklistAutocomplete(String runId) =>
      '$base/runs/$runId/checklists/autocomplete';
  static String runChecklistAdd(String runId, int checklistId) =>
      '$base/runs/$runId/checklists/$checklistId/add';
  static String runChecklistReorder(String runId, int checklistId, int itemId) =>
      '$base/runs/$runId/checklists/$checklistId/item/$itemId/reorder';
  static String runItem(String runId, int checklistId, int itemId) =>
      '$base/runs/$runId/checklists/$checklistId/item/$itemId/run';
  static String runPropertyValue(String runId, String fieldId) =>
      '$base/runs/$runId/property_fields/$fieldId/value';
  static String channelActions(String channelId) => '$base/actions/channels/$channelId';
}