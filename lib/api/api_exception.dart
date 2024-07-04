import 'dart:convert';

import 'package:web_cashboost/api/api_connection.dart';
import 'package:web_cashboost/models/error_model.dart';

class ApiException implements Exception {
  final Response response;

  ApiException(this.response);

  static ErrorModel errorModel(Object e) {
    if(e is ApiException) {
      return ErrorModel.fromMap(jsonDecode(e.response.body));
    }

    return ErrorModel.empty();
  }

  @override
  String toString() {
    return 'ApiException: ${response.statusCode} ${response.body}';
  }
}