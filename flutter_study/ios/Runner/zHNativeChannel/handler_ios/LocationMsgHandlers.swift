import Foundation
import zh_native_channel

// PlatformChannelHandler("LocationMsg")
final class LocationMsgHandlers: ChannelBaseHandler {
    func handle(_ message: any ChannelBaseMsg, completion: @escaping (Result<any ChannelBaseMsg, any Error>) -> Void) {
            guard let message = message as? LocationMsg else {
                completion(Result.failure(ChannelMsgError.typeMismatch(expected: "LocationMsg")))
                return
            }
        completion(Result.success(LocationMsg(lat: "ios receveid: \(message.lat), response lat 123", lng: "ios receveid: \(message.lng), response lng 333")))
    }
}

