import 'package:flutter_test/flutter_test.dart';
import 'package:api_module/api_module.dart';
import 'package:flutter_study/base/api/LoginApi.dart';

/// Mock ApiClientAbstract 用于测试
class MockApiClient extends ApiClientAbstract {
  // 记录调用参数
  String? lastUrl;
  Map<String, dynamic>? lastData;

  // 模拟返回数据
  Map<String, dynamic> mockResponseData = {};
  int mockStatusCode = 200;
  String mockMessage = 'OK';

  @override
  Future<ApiResponse<T>> get<T>(String url) async {
    lastUrl = url;
    return ApiResponse<T>(code: mockStatusCode, message: mockMessage, data: mockResponseData as T);
  }

  @override
  Future<ApiResponse<T>> post<T>(String url, Map<String, dynamic> data) async {
    lastUrl = url;
    lastData = data;
    return ApiResponse<T>(code: mockStatusCode, message: mockMessage, data: mockResponseData as T);
  }

  @override
  Future<ApiResponse<T>> put<T>(String url, Map<String, dynamic> data) async {
    lastUrl = url;
    lastData = data;
    return ApiResponse<T>(code: mockStatusCode, message: mockMessage, data: mockResponseData as T);
  }

  @override
  Future<ApiResponse<T>> delete<T>(String url) async {
    lastUrl = url;
    return ApiResponse<T>(code: mockStatusCode, message: mockMessage, data: mockResponseData as T);
  }
}

void main() {
  group('LoginApi', () {
    late MockApiClient mockApiClient;
    late LoginApi loginApi;

    setUp(() {
      mockApiClient = MockApiClient();
      loginApi = LoginApi(mockApiClient);
    });

    group('login()', () {
      test('should call post with correct url and data', () async {
        // Arrange
        mockApiClient.mockResponseData = {'token': 'test_token_123'};
        mockApiClient.mockStatusCode = 200;
        mockApiClient.mockMessage = 'Success';

        // Act
        await loginApi.login('testuser', 'password123');

        // Assert
        expect(mockApiClient.lastUrl, '/login');
        expect(mockApiClient.lastData, {'username': 'testuser', 'password': 'password123'});
      });

      test('should return LoginResponse with token on success', () async {
        // Arrange
        const expectedToken = 'jwt_token_abc123';
        mockApiClient.mockResponseData = {'token': expectedToken};
        mockApiClient.mockStatusCode = 200;

        // Act
        final result = await loginApi.login('user', 'pass');

        // Assert
        expect(result.code, 200);
        expect(result.data.token, expectedToken);
      });

      test('should return correct status code on failure', () async {
        // Arrange
        mockApiClient.mockResponseData = {'token': ''};
        mockApiClient.mockStatusCode = 401;
        mockApiClient.mockMessage = 'Unauthorized';

        // Act
        final result = await loginApi.login('wronguser', 'wrongpass');

        // Assert
        expect(result.code, 401);
        expect(result.message, 'Unauthorized');
      });
    });
  });

  group('LoginResponse', () {
    test('should create LoginResponse from json', () {
      // Arrange
      final json = {'token': 'my_token'};

      // Act
      final response = LoginResponse.fromJson(json);

      // Assert
      expect(response.token, 'my_token');
    });

    test('should handle empty token', () {
      // Arrange
      final json = {'token': ''};

      // Act
      final response = LoginResponse.fromJson(json);

      // Assert
      expect(response.token, '');
    });
  });
}
