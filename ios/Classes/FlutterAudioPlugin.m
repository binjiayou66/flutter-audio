#import "FlutterAudioPlugin.h"
#import "./Voice/XAVoiceConverter.h"

FlutterMethodChannel* _channel;

@interface FlutterAudioPlugin ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSString *recordPath;

@end

@implementation FlutterAudioPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar 
{
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_audio"
            binaryMessenger:[registrar messenger]];
  FlutterAudioPlugin* instance = [[FlutterAudioPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  _channel = channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result 
{
  NSLog(@"-----%@--%@", call.method, call.arguments);
  if ([@"canRecord" isEqualToString:call.method]) 
  {
    BOOL rt = [self _canRecord];
    result(@(rt));
  } 
  else if ([@"startRecord" isEqualToString:call.method]) 
  {
    if ([call.arguments count] == 0) { 
      result(@(NO));
      return;
    }
    BOOL rt = [self _startRecord:call.arguments[0]];
    result(@(rt));
  } 
  else if ([@"stopRecord" isEqualToString:call.method]) 
  {
    int rt = [self _stopRecord];
    result(@(rt));
  }
  else if ([@"startPlay" isEqualToString:call.method]) 
  {
    if ([call.arguments count] == 0) { 
      result(@(NO));
      return;
    }
    BOOL rt = [self _startPlay:call.arguments[0]];
    result(@(rt));
  }
  else if ([@"stopPlay" isEqualToString:call.method]) 
  {
    BOOL rt = [self _stopPlay];
    result(@(rt));
  }
  else 
  {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [self.player stop];
    self.player = nil;
    [_channel invokeMethod:@"audioPlayerDidFinishPlaying" arguments:@[]];
}


#pragma mark - private methods

- (BOOL)_canRecord
{
  __block BOOL bCanRecord = YES;
  if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
  {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
      [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
        bCanRecord = granted;
      }];
    }
  }
  return bCanRecord;
}

- (BOOL)_startRecord:(NSString *)path
{
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        self.recorder.delegate = nil;
        self.recorder = nil;
        return NO;
    } else {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        if(error){
            NSLog(@"%@", [error description]);
        }
        NSDictionary *recordSetting = @{
          AVSampleRateKey: @(8000.0),
          AVFormatIDKey: @(kAudioFormatLinearPCM),
          AVLinearPCMBitDepthKey: @(16),
          AVNumberOfChannelsKey: @(1),
        };
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
        self.recorder.meteringEnabled = YES;
        if (!self.recorder || error) {
            self.recorder = nil;
            return NO;
        }
        self.startDate = [NSDate date];
        self.recorder.meteringEnabled = YES;
        self.recorder.delegate = self;
        [self.recorder record];
        self.recordPath = path;
        return YES;
    }
}

- (int)_stopRecord
{
    self.endDate = [NSDate date];
    if (self.recorder.recording) {
        [self.recorder stop];
    }
    self.recorder.delegate = nil;
    self.recorder = nil;
    NSString *amrPath = [self.recordPath substringToIndex:self.recordPath.length - 4];
    amrPath = [NSString stringWithFormat:@"%@.amr", amrPath];
    [XAVoiceConverter ConvertWavToAmr:self.recordPath amrSavePath:amrPath];
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

- (BOOL)_startPlay:(NSString *)path
{
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  NSError *err = nil;
  [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
  self.player.numberOfLoops = 0;
  [self.player prepareToPlay];
  self.player.delegate = self;
  [self.player play];
  return YES;
}

- (BOOL)_stopPlay 
{
  [self.player stop];
  self.player = nil;
  self.player.delegate = nil;
  return YES;
}

@end
