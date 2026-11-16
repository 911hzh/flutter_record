import 'package:pigeon/pigeon.dart';

class LocationPigeon {
  final String long;
  final String lat;
  LocationPigeon({required this.long, required this.lat});
}

@HostApi()
abstract class LocationPigeonHostApi {
  LocationPigeon getLocation();
}
