import 'package:web_cashboost/functions/service.dart';

class ApiException implements Exception {
  final Response response;

  ApiException(this.response);

  @override
  String toString() {
    return 'ApiException: ${response.statusCode} ${response.body}';
  }
}