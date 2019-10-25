//
//  XAVoiceConverter.h
//  KSInstantMessaging
//
//  Created by Xiep on 16/02/2017.
//  Copyright © 2017 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface XAVoiceConverter : NSObject

/**
 *  转换wav到amr
 *
 *  @param aWavPath  wav文件路径
 *  @param aSavePath amr保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)ConvertWavToAmr:(NSString *)aWavPath amrSavePath:(NSString *)aSavePath;

/**
 *  转换amr到wav
 *
 *  @param aAmrPath  amr文件路径
 *  @param aSavePath wav保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)ConvertAmrToWav:(NSString *)aAmrPath wavSavePath:(NSString *)aSavePath;

/**
 *	获取录音设置.
 *  建议使用此设置，如有修改，则转换amr时也要对应修改参数，比较麻烦
 *	@returns 录音设置
 */
+ (NSDictionary*)GetAudioRecorderSettingDict;


@end
