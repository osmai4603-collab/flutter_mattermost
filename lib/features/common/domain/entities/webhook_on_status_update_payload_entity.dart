import 'package:flutter_mattermost/features/common/domain/entities/playbook_run_entity.dart';

/// حمولة ويبهوك إنشاء تشغيل (WebhookOnStatusUpdatePayload):
/// جميع حقول PlaybookRun إضافة إلى روابط القناة والتفاصيل.
class WebhookOnStatusUpdatePayloadEntity extends PlaybookRunEntity {
  final String? channel_url;
  final String? details_url;

  const WebhookOnStatusUpdatePayloadEntity({
    super.id,
    super.name,
    super.summary,
    super.is_active,
    super.owner_user_id,
    super.team_id,
    super.channel_id,
    super.create_at,
    super.end_at,
    super.delete_at,
    super.active_stage,
    super.active_stage_title,
    super.post_id,
    super.playbook_id,
    super.checklists,
    this.channel_url,
    this.details_url,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        channel_url,
        details_url,
      ];

  @override
  WebhookOnStatusUpdatePayloadEntity copyWith({
    String? id,
    String? name,
    String? summary,
    bool? is_active,
    String? owner_user_id,
    String? team_id,
    String? channel_id,
    int? create_at,
    int? end_at,
    int? delete_at,
    int? active_stage,
    String? active_stage_title,
    String? post_id,
    String? playbook_id,
    List<Map<String, dynamic>>? checklists,
    String? channel_url,
    String? details_url,
  }) {
    return WebhookOnStatusUpdatePayloadEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      is_active: is_active ?? this.is_active,
      owner_user_id: owner_user_id ?? this.owner_user_id,
      team_id: team_id ?? this.team_id,
      channel_id: channel_id ?? this.channel_id,
      create_at: create_at ?? this.create_at,
      end_at: end_at ?? this.end_at,
      delete_at: delete_at ?? this.delete_at,
      active_stage: active_stage ?? this.active_stage,
      active_stage_title: active_stage_title ?? this.active_stage_title,
      post_id: post_id ?? this.post_id,
      playbook_id: playbook_id ?? this.playbook_id,
      checklists: checklists ?? this.checklists,
      channel_url: channel_url ?? this.channel_url,
      details_url: details_url ?? this.details_url,
    );
  }
}
