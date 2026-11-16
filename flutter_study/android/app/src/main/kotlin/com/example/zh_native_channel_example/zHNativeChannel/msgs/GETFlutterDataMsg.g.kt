// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

package com.example.zh_native_channel_example.zHNativeChannel.msgs

import com.example.zh_native_channel.ChannelBaseMsg
import com.example.zh_native_channel.ChannelMsgException

data class GETFlutterDataMsg(
    val data: String
) : ChannelBaseMsg {
    override fun toMap(): Map<String, Any?> {
        return mapOf(
            "data" to data
        )
    }

    companion object {
        fun fromMap(map: Map<String, Any?>): GETFlutterDataMsg {
            return GETFlutterDataMsg(
                data = map["data"] as? String ?: throw ChannelMsgException("Field data is missing or has invalid type.")
            )
        }
    }
}
