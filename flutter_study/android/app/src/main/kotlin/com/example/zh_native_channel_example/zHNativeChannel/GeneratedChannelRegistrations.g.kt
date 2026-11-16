// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

package com.example.zh_native_channel_example.zHNativeChannel
import com.example.zh_native_channel.ChannelBaseMsgRegister
import com.example.zh_native_channel.ChannelHandlerRegister
import com.example.zh_native_channel.MethodChannelMsgManager
import com.example.zh_native_channel_example.zHNativeChannel.msgs.GETFlutterDataMsg
import com.example.zh_native_channel_example.zHNativeChannel.msgs.LocationMsg
import com.example.flutter_study.zHNativeChannel.handlers.LocactionMsgHandlers

object GeneratedChannelRegistrations {
    fun registerAll() {
        MethodChannelMsgManager.registerMessages(::registerMessages)
        MethodChannelMsgManager.registerHandlers(::registerHandlers)
    }

    fun registerMessages(register: ChannelBaseMsgRegister) {
        register.registerChannel("GETFlutterDataMsg") { GETFlutterDataMsg.fromMap(it) }
        register.registerChannel("LocationMsg") { LocationMsg.fromMap(it) }
    }

    fun registerHandlers(register: ChannelHandlerRegister) {
        register.registerChannel("LocationMsg", LocactionMsgHandlers())
    }
}
