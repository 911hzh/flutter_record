import 'package:injectable/injectable.dart';

@Singleton()
class TestStore {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
  }
}
