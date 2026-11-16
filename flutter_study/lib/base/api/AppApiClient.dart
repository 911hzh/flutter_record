import 'package:flutter_study/base/api/UserApi.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppApiClient {
  AppApiClient({required this.userApi});

  final UserApi userApi;
}
