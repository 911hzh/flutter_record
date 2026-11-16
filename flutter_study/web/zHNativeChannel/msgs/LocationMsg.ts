// 自动生成代码，请勿手动修改
// 由 zh_native_channel_generator/scripts/generate_native_channel.py 生成

import { ChannelBaseMsg, ChannelMap } from '../ChannelBaseMsg';
import { ChannelMsgError } from '../ChannelMsgError';

export class LocationMsg implements ChannelBaseMsg {
  readonly channelName = 'LocationMsg';
  constructor(
    readonly lat: string,
    readonly lng: string
  ) {}

  toMap(): ChannelMap {
    return {
      lat: this.lat,
      lng: this.lng
    };
  }

  static fromMap(map: ChannelMap): LocationMsg {
    const lat = ((map['lat'] as string | null | undefined) ?? (() => { throw new ChannelMsgError('Field lat is missing.'); })());
    const lng = ((map['lng'] as string | null | undefined) ?? (() => { throw new ChannelMsgError('Field lng is missing.'); })());
    return new LocationMsg(lat, lng);
  }
}
