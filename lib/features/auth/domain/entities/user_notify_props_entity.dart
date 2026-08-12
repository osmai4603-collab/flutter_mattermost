import 'package:equatable/equatable.dart';

class UserNotifyPropsEntity extends Equatable {
  final String? email;
  final String? push;
  final String? desktop;
  final String? desktop_sound;
  final String? mention_keys;
  final String? channel;
  final String? first_name;
  final String? auto_responder_message;
  final String? push_threads;
  final String? comments;
  final String? desktop_threads;
  final String? email_threads;

  const UserNotifyPropsEntity({
    this.email,
    this.push,
    this.desktop,
    this.desktop_sound,
    this.mention_keys,
    this.channel,
    this.first_name,
    this.auto_responder_message,
    this.push_threads,
    this.comments,
    this.desktop_threads,
    this.email_threads,
  });

  @override
  List<Object?> get props => [
        email,
        push,
        desktop,
        desktop_sound,
        mention_keys,
        channel,
        first_name,
        auto_responder_message,
        push_threads,
        comments,
        desktop_threads,
        email_threads,
      ];

  UserNotifyPropsEntity copyWith({
    String? email,
    String? push,
    String? desktop,
    String? desktop_sound,
    String? mention_keys,
    String? channel,
    String? first_name,
    String? auto_responder_message,
    String? push_threads,
    String? comments,
    String? desktop_threads,
    String? email_threads,
  }) {
    return UserNotifyPropsEntity(
      email: email ?? this.email,
      push: push ?? this.push,
      desktop: desktop ?? this.desktop,
      desktop_sound: desktop_sound ?? this.desktop_sound,
      mention_keys: mention_keys ?? this.mention_keys,
      channel: channel ?? this.channel,
      first_name: first_name ?? this.first_name,
      auto_responder_message: auto_responder_message ?? this.auto_responder_message,
      push_threads: push_threads ?? this.push_threads,
      comments: comments ?? this.comments,
      desktop_threads: desktop_threads ?? this.desktop_threads,
      email_threads: email_threads ?? this.email_threads,
    );
  }
}
