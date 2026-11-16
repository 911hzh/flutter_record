import Flutter
import Foundation

enum PigeonRegister {
    static func register(binaryMessenger: FlutterBinaryMessenger) {
        LocationPigeonHostApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: LocationPigeonHostApiImpl()
        )
    }
}
