import 'dart:convert';

import 'package:dio/dio.dart';

import 'ApiClientAbstract.dart';
import 'ApiResponse.dart';

class ApiClientAbstractImp extends ApiClientAbstract {
  final Dio dio;
  ApiClientAbstractImp(this.dio) {}
  @override
  Future<ApiResponse<T>> get<T>(String url) async {
    final response = await dio.get(url);
    return ApiResponse<T>(code: response.statusCode ?? 0, message: response.statusMessage ?? "", data: response.data);
  }

  @override
  Future<ApiResponse<T>> post<T>(String url, Map<String, dynamic> data) async {
    final response = await dio.post(url, data: data);
    return ApiResponse<T>(code: response.statusCode ?? 0, message: response.statusMessage ?? "", data: response.data);
  }

  @override
  Future<ApiResponse<T>> put<T>(String url, Map<String, dynamic> data) async {
    final response = await dio.put(url, data: data);
    return ApiResponse<T>(code: response.statusCode ?? 0, message: response.statusMessage ?? "", data: response.data);
  }

  @override
  Future<ApiResponse<T>> delete<T>(String url) async {
    final response = await dio.delete(url);
    return ApiResponse<T>(code: response.statusCode ?? 0, message: response.statusMessage ?? "", data: response.data);
  }
}

extension FutureRestResponseExtension on Future<ApiResponse> {
  Future<ApiResponse<T>> toModel<T>(T Function(Map<String, dynamic>) parser) {
    return then((value) {
      dynamic data = value.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      var model = parser(data);
      return Future.value(ApiResponse<T>(code: value.code, message: value.message, data: model));
    });
  }
}
