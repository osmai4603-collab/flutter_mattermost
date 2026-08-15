/// Standard HTTP Content-Type headers.
enum NetworkContentType {
  json('application/json'),
  formUrlEncoded('application/x-www-form-urlencoded'),
  multipartFormData('multipart/form-data'),
  plainText('text/plain'),
  octetStream('application/octet-stream');

  final String value;
  const NetworkContentType(this.value);
}

/// Standard HTTP Accept headers.
enum NetworkAcceptType {
  json('application/json'),
  all('*/*');

  final String value;
  const NetworkAcceptType(this.value);
}
