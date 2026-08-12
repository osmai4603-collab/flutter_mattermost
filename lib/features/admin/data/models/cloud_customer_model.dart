import 'package:flutter_mattermost/features/admin/domain/entities/cloud_customer_entity.dart';

final class CloudCustomerModel extends CloudCustomerEntity {
  const CloudCustomerModel({
    required super.id,
    required super.creator_id,
    required super.create_at,
    required super.email,
    required super.name,
    required super.num_employees,
    required super.contact_first_name,
    required super.contact_last_name,
    required super.billing_address,
    required super.company_address,
    required super.payment_method,
  });

  factory CloudCustomerModel.fromMap(Map<String, dynamic> map) {
    return CloudCustomerModel(
      id: map["id"] as String?,
      creator_id: map["creator_id"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      email: map["email"] as String?,
      name: map["name"] as String?,
      num_employees: map["num_employees"] as String?,
      contact_first_name: map["contact_first_name"] as String?,
      contact_last_name: map["contact_last_name"] as String?,
      billing_address: map["billing_address"] as Map<String, dynamic>?,
      company_address: map["company_address"] as Map<String, dynamic>?,
      payment_method: map["payment_method"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creator_id": creator_id,
      "create_at": create_at,
      "email": email,
      "name": name,
      "num_employees": num_employees,
      "contact_first_name": contact_first_name,
      "contact_last_name": contact_last_name,
      "billing_address": billing_address,
      "company_address": company_address,
      "payment_method": payment_method,
    };
  }

  factory CloudCustomerModel.fromEntity(CloudCustomerEntity entity) {
    return CloudCustomerModel(
      id: entity.id,
      creator_id: entity.creator_id,
      create_at: entity.create_at,
      email: entity.email,
      name: entity.name,
      num_employees: entity.num_employees,
      contact_first_name: entity.contact_first_name,
      contact_last_name: entity.contact_last_name,
      billing_address: entity.billing_address,
      company_address: entity.company_address,
      payment_method: entity.payment_method,
    );
  }

  CloudCustomerModel copyWith({
    String? id,
    String? creator_id,
    int? create_at,
    String? email,
    String? name,
    String? num_employees,
    String? contact_first_name,
    String? contact_last_name,
    Map<String, dynamic>? billing_address,
    Map<String, dynamic>? company_address,
    Map<String, dynamic>? payment_method,
  }) {
    return CloudCustomerModel(
      id: id ?? this.id,
      creator_id: creator_id ?? this.creator_id,
      create_at: create_at ?? this.create_at,
      email: email ?? this.email,
      name: name ?? this.name,
      num_employees: num_employees ?? this.num_employees,
      contact_first_name: contact_first_name ?? this.contact_first_name,
      contact_last_name: contact_last_name ?? this.contact_last_name,
      billing_address: billing_address ?? this.billing_address,
      company_address: company_address ?? this.company_address,
      payment_method: payment_method ?? this.payment_method,
    );
  }

  CloudCustomerEntity toEntity() => CloudCustomerEntity(
        id: id,
        creator_id: creator_id,
        create_at: create_at,
        email: email,
        name: name,
        num_employees: num_employees,
        contact_first_name: contact_first_name,
        contact_last_name: contact_last_name,
        billing_address: billing_address,
        company_address: company_address,
        payment_method: payment_method,
      );
}
