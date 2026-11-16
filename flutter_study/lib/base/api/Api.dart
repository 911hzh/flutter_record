import 'dart:io';

import 'package:api_module/ApiClientAbstract.dart';
import 'package:api_module/ApiclientAbstractImp.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'LoginApi.dart';

class Api {
  late final ApiClientAbstract apiClient;
  late final LoginApi loginApi = () {
    return LoginApi(apiClient);
  }();
  Api() {
    final dio = Dio();
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          return handler.next(request);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
      ),
    );
    apiClient = ApiClientAbstractImp(Dio());
  }
}
