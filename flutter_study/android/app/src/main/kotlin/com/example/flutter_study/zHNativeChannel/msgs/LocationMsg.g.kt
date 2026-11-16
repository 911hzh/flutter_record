// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

package com.example.flutter_study.zHNativeChannel.msgs

import com.example.zh_native_channel.ChannelBaseMsg
import com.example.zh_native_channel.ChannelMsgException

data class LocationMsg(
    val lat: String,
    val lng: String
) : ChannelBaseMsg {
    override fun toMap(): Map<String, Any?> {
        return mapOf(
            "lat" to lat,
            "lng" to lng
        )
    }

    companion object {
        fun fromMap(map: Map<String, Any?>): LocationMsg {
            return LocationMsg(
                lat = map["lat"] as? String ?: throw ChannelMsgException("Field lat is missing or has invalid type."),
                lng = map["lng"] as? String ?: throw ChannelMsgException("Field lng is missing or has invalid type.")
            )
        }
    }
}
