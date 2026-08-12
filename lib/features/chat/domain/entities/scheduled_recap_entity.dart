import 'package:flutter_mattermost/core/entities/entity.dart';

class ScheduledRecapEntity extends Entity {
  final String id;
  final String userId;
  final String title;
  final int daysOfWeek;
  final String timeOfDay;
  final String timezone;
  final String timePeriod;
  final int nextRunAt;
  final int lastRunAt;
  final int runCount;
  final String channelId;
  final String period;
  final int periodMonth;
  final int periodDay;
  final int lastSentAt;
  final bool paused;
  final String channelMode;
  final List<String> channelIds;
  final String customInstructions;
  final String agentId;
  final bool isRecurring;
  final bool enabled;
  final int createAt;
  final int updateAt;
  final int deleteAt;

  const ScheduledRecapEntity({
    this.id = '',
    this.userId = '',
    this.title = '',
    this.daysOfWeek = 0,
    this.timeOfDay = '',
    this.timezone = '',
    this.timePeriod = '',
    this.nextRunAt = 0,
    this.lastRunAt = 0,
    this.runCount = 0,
    this.channelId = '',
    this.period = '',
    this.periodMonth = 0,
    this.periodDay = 0,
    this.lastSentAt = 0,
    this.paused = false,
    this.channelMode = '',
    this.channelIds = const [],
    this.customInstructions = '',
    this.agentId = '',
    this.isRecurring = false,
    this.enabled = true,
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        daysOfWeek,
        timeOfDay,
        timezone,
        timePeriod,
        nextRunAt,
        lastRunAt,
        runCount,
        channelId,
        period,
        periodMonth,
        periodDay,
        lastSentAt,
        paused,
        channelMode,
        channelIds,
        customInstructions,
        agentId,
        isRecurring,
        enabled,
        createAt,
        updateAt,
        deleteAt,
      ];

  @override
  ScheduledRecapEntity copyWith({
    String? id,
    String? userId,
    String? title,
    int? daysOfWeek,
    String? timeOfDay,
    String? timezone,
    String? timePeriod,
    int? nextRunAt,
    int? lastRunAt,
    int? runCount,
    String? channelId,
    String? period,
    int? periodMonth,
    int? periodDay,
    int? lastSentAt,
    bool? paused,
    String? channelMode,
    List<String>? channelIds,
    String? customInstructions,
    String? agentId,
    bool? isRecurring,
    bool? enabled,
    int? createAt,
    int? updateAt,
    int? deleteAt,
  }) {
    return ScheduledRecapEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      timezone: timezone ?? this.timezone,
      timePeriod: timePeriod ?? this.timePeriod,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      runCount: runCount ?? this.runCount,
      channelId: channelId ?? this.channelId,
      period: period ?? this.period,
      periodMonth: periodMonth ?? this.periodMonth,
      periodDay: periodDay ?? this.periodDay,
      lastSentAt: lastSentAt ?? this.lastSentAt,
      paused: paused ?? this.paused,
      channelMode: channelMode ?? this.channelMode,
      channelIds: channelIds ?? this.channelIds,
      customInstructions: customInstructions ?? this.customInstructions,
      agentId: agentId ?? this.agentId,
      isRecurring: isRecurring ?? this.isRecurring,
      enabled: enabled ?? this.enabled,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }
}
