// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

import Foundation
import zh_native_channel

struct LocationMsg: Codable, ChannelBaseMsg {
    let lat: String
    let lng: String

    init(lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
    }

    init(map: [String: Any]) throws {
        self.lat = try ((map["lat"] as? String) ?? ChannelMsgMapCoder.missingField("lat"))
        self.lng = try ((map["lng"] as? String) ?? ChannelMsgMapCoder.missingField("lng"))
    }
}
