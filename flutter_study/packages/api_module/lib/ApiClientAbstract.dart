import 'ApiResponse.dart';

abstract class ApiClientAbstract {
  Future<ApiResponse<T>> get<T>(String url);
  Future<ApiResponse<T>> post<T>(String url, Map<String, dynamic> data);
  Future<ApiResponse<T>> put<T>(String url, Map<String, dynamic> data);
  Future<ApiResponse<T>> delete<T>(String url);
}
