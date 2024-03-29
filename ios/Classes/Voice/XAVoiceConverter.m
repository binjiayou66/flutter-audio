//
//  XAVoiceConverter.m
//  KSInstantMessaging
//
//  Created by Xiep on 16/02/2017.
//  Copyright © 2017 Andrew Shen. All rights reserved.
//

#import "XAVoiceConverter.h"
#import "amrFileCodec.h"

@implementation XAVoiceConverter

//转换amr到wav
+ (int)ConvertAmrToWav:(NSString *)aAmrPath wavSavePath:(NSString *)aSavePath{
    
    if (! DecodeAMRFileToWAVEFile([aAmrPath cStringUsingEncoding:NSASCIIStringEncoding], [aSavePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return 0;
    
    return 1;
}

//转换wav到amr
+ (int)ConvertWavToAmr:(NSString *)aWavPath amrSavePath:(NSString *)aSavePath{
    
    if (! EncodeWAVEFileToAMRFile([aWavPath cStringUsingEncoding:NSASCIIStringEncoding], [aSavePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return 0;
    
    return 1;
}

//获取录音设置
+ (NSDictionary*)GetAudioRecorderSettingDict{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,          //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,          //采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,          //通道的数目
                                   nil];
    return recordSetting;
}

@end
