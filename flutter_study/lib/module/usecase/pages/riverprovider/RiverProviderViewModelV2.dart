import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverProviderStateV2 {
  const RiverProviderStateV2({
    required this.count,
    required this.message,
    required this.isLoading,
  });

  const RiverProviderStateV2.initial()
    : count = 0,
      message = '初始化完成',
      isLoading = false;

  final int count;
  final String message;
  final bool isLoading;
}

class RiverProviderViewModelV2 extends Notifier<RiverProviderStateV2> {
  @override
  RiverProviderStateV2 build() {
    return const RiverProviderStateV2.initial();
  }
}
