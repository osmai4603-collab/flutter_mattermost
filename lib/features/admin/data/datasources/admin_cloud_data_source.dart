import 'package:flutter_mattermost/features/admin/data/models/cloud_customer_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/product_limits_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/subscription_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/invoice_model.dart';

abstract class AdminCloudDataSource {
  Future<CloudCustomerModel> getCloudCustomer();
  Future<CloudCustomerModel> updateCloudCustomer(
    Map<String, dynamic> customer,
  );
  Future<Map<String, dynamic>> getCloudCustomerAddress();
  Future<Map<String, dynamic>> updateCloudCustomerAddress(
    Map<String, dynamic> address,
  );
  Future<Map<String, dynamic>> getCloudProducts();
  Future<SubscriptionModel> getCloudSubscription();
  Future<ProductLimitsModel> getCloudLimits();
  Future<List<InvoiceModel>> getCloudInvoices();
  Future<void> downloadCloudInvoicePdf(String invoiceId, String savePath);
  Future<void> checkCwsConnection();
  Future<void> validateBusinessEmail(String email);
  Future<void> validateWorkspaceBusinessEmail(String email);
  Future<Map<String, dynamic>> getCloudPreviewModalData({
    Map<String, dynamic>? productName,
    String? plan,
    bool isYearly = false,
  });
  Future<Map<String, dynamic>> getUsagePosts();
  Future<Map<String, dynamic>> getUsageStorage();
  Future<Map<String, dynamic>> getUsageTeams();
  Future<Map<String, dynamic>> getLatestVersion();
  Future<bool> isHostedCustomerSignupAvailable();
  Future<Map<String, dynamic>> getInstallationInfo();
  Future<void> postCwsWebhook(Map<String, dynamic> data);
}

@LazySingleton(as: AdminCloudDataSource)
class AdminCloudDataSourceImpl implements AdminCloudDataSource {
  final ApiClient _apiClient;

  AdminCloudDataSourceImpl(this._apiClient);

  Map<String, dynamic> _mapFrom(
    ApiResult<Map<String, dynamic>> result,
    String error,
  ) {
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception(error);
  }

  @override
  Future<CloudCustomerModel> getCloudCustomer() async {
    final result = await _apiClient.get<CloudCustomerModel>(
      CloudEndPoint.customer,
      fromJson: (json) => CloudCustomerModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CloudCustomerModel>) {
      return result.data;
    }
    throw Exception('Failed to get cloud customer');
  }

  @override
  Future<CloudCustomerModel> updateCloudCustomer(
    Map<String, dynamic> customer,
  ) async {
    final result = await _apiClient.put<CloudCustomerModel>(
      CloudEndPoint.customer,
      data: customer,
      fromJson: (json) => CloudCustomerModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CloudCustomerModel>) {
      return result.data;
    }
    throw Exception('Failed to update cloud customer');
  }

  @override
  Future<Map<String, dynamic>> getCloudCustomerAddress() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      CloudEndPoint.customerAddress,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get cloud customer address');
  }

  @override
  Future<Map<String, dynamic>> updateCloudCustomerAddress(
    Map<String, dynamic> address,
  ) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
      CloudEndPoint.customerAddress,
      data: address,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to update cloud customer address');
  }

  @override
  Future<Map<String, dynamic>> getCloudProducts() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      CloudEndPoint.products,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get cloud products');
  }

  @override
  Future<SubscriptionModel> getCloudSubscription() async {
    final result = await _apiClient.get<SubscriptionModel>(
      CloudEndPoint.subscription,
      fromJson: (json) => SubscriptionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<SubscriptionModel>) {
      return result.data;
    }
    throw Exception('Failed to get cloud subscription');
  }

  @override
  Future<ProductLimitsModel> getCloudLimits() async {
    final result = await _apiClient.get<ProductLimitsModel>(
      CloudEndPoint.limits,
      fromJson: (json) => ProductLimitsModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ProductLimitsModel>) {
      return result.data;
    }
    throw Exception('Failed to get cloud limits');
  }

  @override
  Future<List<InvoiceModel>> getCloudInvoices() async {
    final result = await _apiClient.get<List<InvoiceModel>>(
      CloudEndPoint.subscriptionInvoices,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => InvoiceModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<InvoiceModel>>) {
      return result.data;
    }
    throw Exception('Failed to get cloud invoices');
  }

  @override
  Future<void> downloadCloudInvoicePdf(
    String invoiceId,
    String savePath,
  ) async {
    final response = await _apiClient.dio.download(
      CloudEndPoint.subscriptionInvoicesPdf(invoiceId),
      savePath,
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to download invoice');
    }
  }

  @override
  Future<void> checkCwsConnection() async {
    final result = await _apiClient.post<void>(
      CloudEndPoint.checkCwsConnection,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('CWS connection check failed');
    }
  }

  @override
  Future<void> validateBusinessEmail(String email) async {
    final result = await _apiClient.post<void>(
      CloudEndPoint.validateBusinessEmail,
      data: {'email': email},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Business email validation failed');
    }
  }

  @override
  Future<void> validateWorkspaceBusinessEmail(String email) async {
    final result = await _apiClient.post<void>(
      CloudEndPoint.validateWorkspaceBusinessEmail,
      data: {'email': email},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Workspace business email validation failed');
    }
  }

  @override
  Future<Map<String, dynamic>> getCloudPreviewModalData({
    Map<String, dynamic>? productName,
    String? plan,
    bool isYearly = false,
  }) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      CloudEndPoint.previewModalData,
      queryParameters: {
        'product_name': productName,
        'plan': plan,
        'is_yearly': isYearly,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get preview modal data');
  }

  @override
  Future<Map<String, dynamic>> getUsagePosts() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsageEndPoint.posts,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get posts usage');
  }

  @override
  Future<Map<String, dynamic>> getUsageStorage() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsageEndPoint.storage,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get storage usage');
  }

  @override
  Future<Map<String, dynamic>> getUsageTeams() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsageEndPoint.teams,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get teams usage');
  }

  @override
  Future<Map<String, dynamic>> getLatestVersion() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      LatestVersionEndPoint.root,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get latest version');
  }

  @override
  Future<bool> isHostedCustomerSignupAvailable() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      HostedCustomerEndPoint.signupAvailable,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['available'] as bool?) ?? false;
    }
    throw Exception('Failed to check hosted customer signup');
  }

  @override
  Future<Map<String, dynamic>> getInstallationInfo() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      CloudEndPoint.installation,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to get installation info');
  }

  @override
  Future<void> postCwsWebhook(Map<String, dynamic> data) async {
    final result = await _apiClient.post<void>(
      CloudEndPoint.webhook,
      data: data,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to post CWS webhook');
    }
  }
}
