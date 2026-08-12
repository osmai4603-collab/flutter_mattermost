import 'package:equatable/equatable.dart';

class ChannelNotifyPropsEntity extends Equatable {
  final String? email;
  final String? push;
  final String? desktop;
  final String? mark_unread;

  const ChannelNotifyPropsEntity({
    this.email,
    this.push,
    this.desktop,
    this.mark_unread,
  });

  @override
  List<Object?> get props => [
        email,
        push,
        desktop,
        mark_unread,
      ];

  ChannelNotifyPropsEntity copyWith({
    String? email,
    String? push,
    String? desktop,
    String? mark_unread,
  }) {
    return ChannelNotifyPropsEntity(
      email: email ?? this.email,
      push: push ?? this.push,
      desktop: desktop ?? this.desktop,
      mark_unread: mark_unread ?? this.mark_unread,
    );
  }
}
