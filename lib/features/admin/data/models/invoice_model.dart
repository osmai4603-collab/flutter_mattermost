import 'package:flutter_mattermost/features/admin/domain/entities/invoice_entity.dart';

final class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.number,
    required super.create_at,
    required super.total,
    required super.tax,
    required super.status,
    required super.period_start,
    required super.period_end,
    required super.subscription_id,
    required super.item,
  });

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map["id"] as String?,
      number: map["number"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      total: (map["total"] as num?)?.toInt(),
      tax: (map["tax"] as num?)?.toInt(),
      status: map["status"] as String?,
      period_start: (map["period_start"] as num?)?.toInt(),
      period_end: (map["period_end"] as num?)?.toInt(),
      subscription_id: map["subscription_id"] as String?,
      item: (map["item"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "number": number,
      "create_at": create_at,
      "total": total,
      "tax": tax,
      "status": status,
      "period_start": period_start,
      "period_end": period_end,
      "subscription_id": subscription_id,
      "item": item,
    };
  }

  factory InvoiceModel.fromEntity(InvoiceEntity entity) {
    return InvoiceModel(
      id: entity.id,
      number: entity.number,
      create_at: entity.create_at,
      total: entity.total,
      tax: entity.tax,
      status: entity.status,
      period_start: entity.period_start,
      period_end: entity.period_end,
      subscription_id: entity.subscription_id,
      item: entity.item,
    );
  }

  InvoiceModel copyWith({
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
    return InvoiceModel(
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

  InvoiceEntity toEntity() => InvoiceEntity(
        id: id,
        number: number,
        create_at: create_at,
        total: total,
        tax: tax,
        status: status,
        period_start: period_start,
        period_end: period_end,
        subscription_id: subscription_id,
        item: item,
      );
}
