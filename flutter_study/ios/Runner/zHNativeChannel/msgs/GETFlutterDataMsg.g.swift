// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

import Foundation
import zh_native_channel

struct GETFlutterDataMsg: Codable, ChannelBaseMsg {
    let data: String

    init(data: String) {
        self.data = data
    }

    init(map: [String: Any]) throws {
        self.data = try ((map["data"] as? String) ?? ChannelMsgMapCoder.missingField("data"))
    }
}
