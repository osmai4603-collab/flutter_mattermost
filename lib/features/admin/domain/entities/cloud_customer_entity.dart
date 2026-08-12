import 'package:equatable/equatable.dart';

class CloudCustomerEntity extends Equatable {
  final String? id;
  final String? creator_id;
  final int? create_at;
  final String? email;
  final String? name;
  final String? num_employees;
  final String? contact_first_name;
  final String? contact_last_name;
  final Map<String, dynamic>? billing_address;
  final Map<String, dynamic>? company_address;
  final Map<String, dynamic>? payment_method;

  const CloudCustomerEntity({
    this.id,
    this.creator_id,
    this.create_at,
    this.email,
    this.name,
    this.num_employees,
    this.contact_first_name,
    this.contact_last_name,
    this.billing_address,
    this.company_address,
    this.payment_method,
  });

  @override
  List<Object?> get props => [
        id,
        creator_id,
        create_at,
        email,
        name,
        num_employees,
        contact_first_name,
        contact_last_name,
        billing_address,
        company_address,
        payment_method,
      ];

  CloudCustomerEntity copyWith({
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
    return CloudCustomerEntity(
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
}
