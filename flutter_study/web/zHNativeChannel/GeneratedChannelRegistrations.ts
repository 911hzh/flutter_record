// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

import { ChannelBaseMsgRegister } from './ChannelBaseMsgRegister';
import { ChannelHandlerRegister } from './ChannelHandlerRegister';
import { GETFlutterDataMsg } from './msgs/GETFlutterDataMsg';
import { LocationMsg } from './msgs/LocationMsg';

export function registerGeneratedChannelMessages(register: ChannelBaseMsgRegister): void {
  register.registerChannel('GETFlutterDataMsg', (map) => GETFlutterDataMsg.fromMap(map));
  register.registerChannel('LocationMsg', (map) => LocationMsg.fromMap(map));
}

export function registerGeneratedChannelHandlers(register: ChannelHandlerRegister): void {
  // 在这里注册手写的 Web handler。
}
