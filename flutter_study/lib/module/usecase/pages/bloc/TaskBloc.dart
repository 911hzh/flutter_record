import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<int, List<String>> {
  TaskBloc({required EventTransformer<int> transformer}) : super([]) {
    on<int>((id, emit) async {
      emit([...state, '照片 $id 开始上传']);
      await Future<void>.delayed(Duration(milliseconds: id.isOdd ? 1200 : 300));
      if (emit.isDone) return;
      emit([...state, '照片 $id 上传完成']);
    }, transformer: transformer);
  }
}
