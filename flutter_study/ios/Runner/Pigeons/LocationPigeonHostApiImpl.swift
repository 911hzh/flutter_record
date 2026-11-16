import Foundation

final class LocationPigeonHostApiImpl: LocationPigeonHostApi {
    func getLocation() throws -> LocationPigeon {
        LocationPigeon(long: "116.397128", lat: "39.916527")
    }
}
