//
//  AudioHelper.m
//  Yumi
//
//  Created by Mao on 15/1/25.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "AudioHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioHelper()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign)   BOOL    isCanceled;

@end

@implementation AudioHelper


+ (AudioHelper *)shared{
    static AudioHelper *shared_ = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared_ = [[AudioHelper alloc] init];
    });
    return shared_;
}
-(void)dealloc{
    if (self.audioRecorder != nil) {
        if ([self.audioRecorder isRecording] == YES) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
    
    if (self.audioPlayer != nil) {
        if ([self.audioPlayer isPlaying] == YES) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
}
-(id)init{
    if (self= [super init]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        self.path = [docDir stringByAppendingPathComponent:@"record"];
    }
    return self;
}
-(void)setPath:(NSString *)path{
    _path = path;
    //判断是文件夹是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDir == NO || existed == NO){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//在初始化AVAudioRecord实例之前，需要进行基本的录音设置
- (NSDictionary *)audioRecordingSettings{
    
    NSDictionary *result = nil;
    
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];//录音时所必需的参数设置
    
    [settings setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless]
                forKey:AVFormatIDKey];
    
    [settings setValue:[NSNumber numberWithFloat:44100.0f] forKey:AVSampleRateKey];
    
    [settings setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    
    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityLow]
                forKey:AVEncoderAudioQualityKey];
    
    result = [NSDictionary dictionaryWithDictionary:settings];
    
    return (result);
}

-(BOOL)recordWithName:(NSString *)name{
    NSError *error = nil;
    NSString *pathOfRecordingFile = [self.path stringByAppendingPathComponent:name];
    NSURL *audioRecordingUrl = [NSURL fileURLWithPath:pathOfRecordingFile];
    self.isCanceled = NO;
    if (self.audioRecorder != nil) {
        if ([self.audioRecorder isRecording] == YES) {
            self.isCanceled = YES;
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
    
    
    self.audioRecorder = [[AVAudioRecorder alloc]
                                    initWithURL:audioRecordingUrl
                                    settings:[self audioRecordingSettings]
                                    error:&error];
    
    if (self.audioRecorder != nil) {
        self.audioRecorder.delegate = self;
        
        if ([self.audioRecorder prepareToRecord] == YES &&
            [self.audioRecorder record] == YES) {
            NSLog(@"录制声音开始！");
            return YES;
        } else {
            NSLog(@"录制失败！");
            self.audioRecorder =nil;
        }
    } else {
        NSLog(@"auioRecorder实例创建失败！");
    }
    return NO;
}
-(void)cancelRecord{
    self.isCanceled = YES;
    if (self.audioRecorder != nil) {
        if ([self.audioRecorder isRecording] == YES) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
}
//停止音频的录制
- (void)stopRecord{
    self.isCanceled = NO;
    if (self.audioRecorder != nil) {
        if ([self.audioRecorder isRecording] == YES) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
}

-(void)playWithName:(NSString *)name{
    [self stopPlay];
    NSError *playbackError = nil;
    NSError *readingError = nil;
    NSString *pathOfRecordingFile = [self.path stringByAppendingPathComponent:name];
    NSData *fileData = [NSData dataWithContentsOfFile:pathOfRecordingFile options:NSDataReadingMapped error:&readingError];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                             error:&playbackError];
    
    if (self.audioPlayer != nil) {
        self.audioPlayer.delegate = self;
        if ([self.audioPlayer prepareToPlay] == YES &&
            [self.audioPlayer play] == YES) {
            NSLog(@"开始播放录制的音频！");
        } else {
            NSLog(@"不能播放录制的音频！");
        }
    }else {
        NSLog(@"音频播放失败！");
    }
}
-(void)stopPlay{
    if (self.audioPlayer != nil) {
        if ([self.audioPlayer isPlaying] == YES) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
}

//当AVAudioRecorder对象录音终止的时候会调用audioRecorderDidFinishRecording:successfully:方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (self.isCanceled) {
        return;
    }
    //如果flag为真，代表录音正常结束，使用AVAudioPlayer将其播放出来，否则日志记录失败原因
    if (flag == YES) {
        NSLog(@"录音完成！");
    } else {
        NSLog(@"录音过程意外终止！");
    }
    self.audioRecorder = nil;
}


@end
