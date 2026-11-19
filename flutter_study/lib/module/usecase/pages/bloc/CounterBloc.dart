import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  final transitions = ValueNotifier<List<String>>([]);

  CounterBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      switch (event) {
        case CounterEvent.increment:
          emit(state + 1);
        case CounterEvent.decrement:
          emit(state - 1);
      }
    });
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    super.onTransition(transition);
    transitions.value = [
      '${transition.event.name}：${transition.currentState} → ${transition.nextState}',
      ...transitions.value.take(5),
    ];
  }

  @override
  Future<void> close() async {
    await super.close();
    transitions.dispose();
  }
}
