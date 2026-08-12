sealed class CloudEndPoint {
  CloudEndPoint._();

  static const String base = '/cloud';
  static const String root = base;
  static const String connection = '$base/connection';
  static const String checkCwsConnection = '$base/check-cws-connection';
  static const String customer = '$base/customer';
  static const String customerAddress = '$base/customer/address';
  static const String installation = '$base/installation';
  static const String limits = '$base/limits';
  static const String previewModalData = '$base/preview/modal_data';
  static const String products = '$base/products';
  static const String subscription = '$base/subscription';
  static const String subscriptionInvoices = '$base/subscription/invoices';
  static String subscriptionInvoicesPdf(String invoiceId) =>
      '$base/subscription/invoices/$invoiceId/pdf';
  static const String validateBusinessEmail = '$base/validate-business-email';
  static const String validateWorkspaceBusinessEmail =
      '$base/validate-workspace-business-email';
  static const String webhook = '$base/webhook';
}
