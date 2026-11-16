import 'package:flutter_bloc/flutter_bloc.dart';

class PigeonDemoState {
  final String result;
  final bool loading;

  const PigeonDemoState({required this.result, required this.loading});

  factory PigeonDemoState.initial() {
    return const PigeonDemoState(result: "点击按钮开始模拟 Pigeon 调用", loading: false);
  }

  PigeonDemoState copyWith({String? result, bool? loading}) {
    return PigeonDemoState(
      result: result ?? this.result,
      loading: loading ?? this.loading,
    );
  }
}

class PigeonDemoBloc extends Cubit<PigeonDemoState> {
  PigeonDemoBloc() : super(PigeonDemoState.initial());

  Future<void> mockPigeonCall() async {
    emit(state.copyWith(loading: true, result: "正在通过类型安全接口请求原生数据..."));

    await Future<void>.delayed(const Duration(milliseconds: 600));

    emit(
      state.copyWith(
        loading: false,
        result:
            "Pigeon Demo Result\nname: Flutter Study\nplatform: iOS/Android native",
      ),
    );
  }
}
