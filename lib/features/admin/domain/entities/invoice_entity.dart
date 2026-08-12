import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String? id;
  final String? number;
  final int? create_at;
  final int? total;
  final int? tax;
  final String? status;
  final int? period_start;
  final int? period_end;
  final String? subscription_id;
  final List<Map<String, dynamic>>? item;

  const InvoiceEntity({
    this.id,
    this.number,
    this.create_at,
    this.total,
    this.tax,
    this.status,
    this.period_start,
    this.period_end,
    this.subscription_id,
    this.item,
  });

  @override
  List<Object?> get props => [
        id,
        number,
        create_at,
        total,
        tax,
        status,
        period_start,
        period_end,
        subscription_id,
        item,
      ];

  InvoiceEntity copyWith({
    String? id,
    String? number,
    int? create_at,
    int? total,
    int? tax,
    String? status,
    int? period_start,
    int? period_end,
    String? subscription_id,
    List<Map<String, dynamic>>? item,
  }) {
    return InvoiceEntity(
      id: id ?? this.id,
      number: number ?? this.number,
      create_at: create_at ?? this.create_at,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      status: status ?? this.status,
      period_start: period_start ?? this.period_start,
      period_end: period_end ?? this.period_end,
      subscription_id: subscription_id ?? this.subscription_id,
      item: item ?? this.item,
    );
  }
}
