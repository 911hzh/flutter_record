// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

import { ChannelBaseMsg, ChannelMap } from '../ChannelBaseMsg';
import { ChannelMsgError } from '../ChannelMsgError';

export class GETFlutterDataMsg implements ChannelBaseMsg {
  readonly channelName = 'GETFlutterDataMsg';
  constructor(
    readonly data: string
  ) {}

  toMap(): ChannelMap {
    return {
      data: this.data
    };
  }

  static fromMap(map: ChannelMap): GETFlutterDataMsg {
    const data = ((map['data'] as string | null | undefined) ?? (() => { throw new ChannelMsgError('Field data is missing.'); })());
    return new GETFlutterDataMsg(data);
  }
}
