// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_foundation_kit/flutter_foundation_kit.dart' as _i698;
import 'package:flutter_foundation_kit/wcore/Repository.dart' as _i38;
import 'package:flutter_foundation_kit/wcore/settings/SettingsLoader.dart'
    as _i248;
import 'package:flutter_study/base/api/AppApiClient.dart' as _i755;
import 'package:flutter_study/base/api/AppNetworkProxy.dart' as _i617;
import 'package:flutter_study/base/api/AppRestClientAdapter.dart' as _i278;
import 'package:flutter_study/base/api/UserApi.dart' as _i468;
import 'package:flutter_study/base/store/auth/AuthStoreImpl.dart' as _i983;
import 'package:flutter_study/base/store/settings/Settings.dart' as _i640;
import 'package:flutter_study/base/store/settings/SettingsStore.dart' as _i94;
import 'package:flutter_study/base/store/user/UserStoreImpl.dart' as _i386;
import 'package:flutter_study/module/getIt/RegisterModule.dart' as _i854;
import 'package:flutter_study/TestStore.dart' as _i235;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i235.TestStore>(() => _i235.TestStore());
    gh.lazySingleton<_i698.Repository>(
      () => registerModule.userPreferenceRepository(),
      instanceName: 'userPreferenceRepository',
    );
    gh.lazySingleton<_i248.SettingsLoader>(() => _i640.DefaultSettingsLoader());
    gh.lazySingleton<_i698.Repository>(
      () => registerModule.authRepository(),
      instanceName: 'authRepository',
    );
    gh.lazySingleton<_i698.NetworkProxy>(() => _i617.AppNetworkProxy());
    gh.lazySingleton<_i94.SettingsStore>(
      () => _i94.SettingsStore(settingsLoader: gh<_i248.SettingsLoader>()),
    );
    gh.lazySingleton<_i983.AuthStoreImpl>(
      () => _i983.AuthStoreImpl(
        keychainPort: gh<_i38.Repository>(instanceName: 'authRepository'),
      ),
    );
    gh.lazySingleton<_i698.RestClientAdapter>(
      () => _i278.AppRestClientAdapter(settingsStore: gh<_i94.SettingsStore>()),
    );
    gh.lazySingleton<_i698.RestClient>(
      () => registerModule.restClient(
        gh<_i698.RestClientAdapter>(),
        gh<_i698.NetworkProxy>(),
      ),
    );
    gh.lazySingleton<_i468.UserApi>(
      () => _i468.UserApi(client: gh<_i698.RestClient>()),
    );
    gh.lazySingleton<_i755.AppApiClient>(
      () => _i755.AppApiClient(userApi: gh<_i468.UserApi>()),
    );
    gh.lazySingleton<_i386.UserStoreImpl>(
      () => _i386.UserStoreImpl(
        apiClient: gh<_i755.AppApiClient>(),
        authStore: gh<_i983.AuthStoreImpl>(),
        preferenceRepositoryPort: gh<_i38.Repository>(
          instanceName: 'userPreferenceRepository',
        ),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i854.RegisterModule {}
