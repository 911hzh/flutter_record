package com.example.flutter_study.zHNativeChannel.handlers

import com.example.flutter_study.zHNativeChannel.msgs.LocationMsg
import com.example.zh_native_channel.ChannelBaseHandler
import com.example.zh_native_channel.ChannelBaseMsg

// PlatformChannelHandler("LocationMsg")
class LocactionMsgHandlers : ChannelBaseHandler {
    override fun handle(message: ChannelBaseMsg): ChannelBaseMsg {
        return LocationMsg(lat = "31.2304", lng = "121.4737")
    }
}
