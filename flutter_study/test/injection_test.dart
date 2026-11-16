import 'package:flutter_study/base/api/AppApiClient.dart';
import 'package:flutter_study/base/api/UserApi.dart';
import 'package:flutter_study/base/store/auth/AuthStoreImpl.dart';
import 'package:flutter_study/base/store/settings/SettingsStore.dart';
import 'package:flutter_study/base/store/user/UserStoreImpl.dart';
import 'package:flutter_study/module/getIt/Injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    await configureDependencies();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('resolves registered dependencies', () {
    final apiClient = getIt<AppApiClient>();

    expect(apiClient.userApi, same(getIt<UserApi>()));
    expect(getIt<SettingsStore>(), isA<SettingsStore>());
    expect(getIt<AuthStoreImpl>(), isA<AuthStoreImpl>());
    expect(getIt<UserStoreImpl>(), isA<UserStoreImpl>());
  });
}
