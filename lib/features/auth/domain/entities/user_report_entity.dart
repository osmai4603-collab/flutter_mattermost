import 'package:equatable/equatable.dart';

class UserReportEntity extends Equatable {
  final String? id;
  final int? create_at;
  final int? update_at;
  final int? delete_at;
  final String? username;
  final String? auth_data;
  final String? auth_service;
  final String? email;
  final String? nickname;
  final String? first_name;
  final String? last_name;
  final String? position;
  final String? roles;
  final String? locale;
  final Map<String, dynamic>? timezone;
  final bool? disable_welcome_email;
  final int? last_login;
  final int? last_status_at;
  final int? last_post_date;
  final int? days_active;
  final int? total_posts;

  const UserReportEntity({
    this.id,
    this.create_at,
    this.update_at,
    this.delete_at,
    this.username,
    this.auth_data,
    this.auth_service,
    this.email,
    this.nickname,
    this.first_name,
    this.last_name,
    this.position,
    this.roles,
    this.locale,
    this.timezone,
    this.disable_welcome_email,
    this.last_login,
    this.last_status_at,
    this.last_post_date,
    this.days_active,
    this.total_posts,
  });

  @override
  List<Object?> get props => [
        id,
        create_at,
        update_at,
        delete_at,
        username,
        auth_data,
        auth_service,
        email,
        nickname,
        first_name,
        last_name,
        position,
        roles,
        locale,
        timezone,
        disable_welcome_email,
        last_login,
        last_status_at,
        last_post_date,
        days_active,
        total_posts,
      ];

  UserReportEntity copyWith({
    String? id,
    int? create_at,
    int? update_at,
    int? delete_at,
    String? username,
    String? auth_data,
    String? auth_service,
    String? email,
    String? nickname,
    String? first_name,
    String? last_name,
    String? position,
    String? roles,
    String? locale,
    Map<String, dynamic>? timezone,
    bool? disable_welcome_email,
    int? last_login,
    int? last_status_at,
    int? last_post_date,
    int? days_active,
    int? total_posts,
  }) {
    return UserReportEntity(
      id: id ?? this.id,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
      username: username ?? this.username,
      auth_data: auth_data ?? this.auth_data,
      auth_service: auth_service ?? this.auth_service,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      position: position ?? this.position,
      roles: roles ?? this.roles,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      disable_welcome_email: disable_welcome_email ?? this.disable_welcome_email,
      last_login: last_login ?? this.last_login,
      last_status_at: last_status_at ?? this.last_status_at,
      last_post_date: last_post_date ?? this.last_post_date,
      days_active: days_active ?? this.days_active,
      total_posts: total_posts ?? this.total_posts,
    );
  }
}
