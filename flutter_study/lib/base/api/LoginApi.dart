import 'package:api_module/api_module.dart';

class LoginApi {
  final ApiClientAbstract apiClient;
  LoginApi(this.apiClient);
  Future<ApiResponse<LoginResponse>> login(String username, String password) async {
    return apiClient.post('/login', {'username': username, 'password': password}).toModel(LoginResponse.fromJson);
  }
}

class LoginResponse {
  final String token;
  LoginResponse({required this.token});
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}
