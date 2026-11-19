import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<String> riverProviderTitleProvider = Provider<String>((Ref ref) {
  return 'Riverpod 基础用法';
});

final NotifierProvider<RiverProviderViewModel, RiverProviderState>
riverProviderViewModelProvider =
    NotifierProvider.autoDispose<RiverProviderViewModel, RiverProviderState>(
      RiverProviderViewModel.new,
    );

class RiverProviderState {
  const RiverProviderState({
    required this.count,
    required this.message,
    required this.isLoading,
  });

  const RiverProviderState.initial()
    : count = 0,
      message = '初始化完成',
      isLoading = false;

  final int count;
  final String message;
  final bool isLoading;

  RiverProviderState copyWith({int? count, String? message, bool? isLoading}) {
    return RiverProviderState(
      count: count ?? this.count,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RiverProviderViewModel extends Notifier<RiverProviderState> {
  @override
  RiverProviderState build() {
    return const RiverProviderState.initial();
  }

  void increment() {
    state = state.copyWith(
      count: state.count + 1,
      message: 'count +1，当前 count: ${state.count + 1}',
    );
  }

  void decrement() {
    state = state.copyWith(
      count: state.count - 1,
      message: 'count -1，当前 count: ${state.count - 1}',
    );
  }

  void reset() {
    state = const RiverProviderState.initial();
  }

  Future<void> reloadMessage() async {
    state = state.copyWith(isLoading: true);
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!ref.mounted) {
      return;
    }

    state = state.copyWith(
      isLoading: false,
      message: '异步读取完成，当前 count: ${state.count}',
    );
  }
}
