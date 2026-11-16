import "package:flutter/foundation.dart";
import "package:flutter_study/base/InjectorConfig.config.dart";
import "package:get_it/get_it.dart";
import "package:injectable/injectable.dart";

@InjectableInit()
void configureDependencies() {
  var getIt = GetIt.instance;
  getIt.init();
  // getIt.init();
  // _configure(getIt);
  // getIt.init();
  // _loaded(getIt);
}

// void _configure(GetIt di) {
//   di.registerSingleton<Nativebus>(kIsWeb ? NativebusWeb() : Nativebus());
// }

// void _loaded(GetIt di) {
//   di.registerSingleton(
//     AgentClient(
//       BrainRestClientImpl(
//         restAdapter: AgentRestClientAdapter(di.get<AuthStore>(), di.get<AppInfoStore>(), di.get<Extras>()),
//         apiLocalInterceptor: di.get<ApiLocalInterceptor>(),
//         networkProxy: di.get<NetworkProxy>(),
//       ),
//     ),
//   );
//   MapboxOptions.setAccessToken(settings.mapboxPublicKey);
//   di.get<MeStore>().setBrainClient(di.get<ApiClient>());
//   di.get<UserPreferencesStore>().setBrainClient(di.get<ApiClient>());
//   di.get<ShoppingDetailStore>().setBrainClient(di.get<ApiClient>());

//   var conversationStore = ConversationStore(di.get<AgentClient>(), di.get<MeStore>(), di.get<SimpleAblyImpl>());
//   di.registerSingleton(conversationStore);
// }
