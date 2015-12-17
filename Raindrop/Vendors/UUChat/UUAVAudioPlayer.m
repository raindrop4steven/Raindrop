//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by shake on 14-9-1.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUAVAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>


@interface UUAVAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *palyerArray;
@property (nonatomic, strong)AVAudioPlayer *voicePlayer;
@property (nonatomic, strong)AVAudioPlayer *bgPlayer;
@end

@implementation UUAVAudioPlayer

+ (UUAVAudioPlayer *)sharedInstance
{
    static UUAVAudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });    
    return sharedInstance;
}

-(void)playSongWithUrl:(NSString *)songUrl
{
    
    dispatch_async(dispatch_queue_create("playSoundFromUrl", NULL), ^{
        [self.delegate UUAVAudioPlayerBeiginLoadVoice];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:songUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playSoundWithData:data];
        });
    });
}

-(void)playSongWithData:(NSData *)songData
{
    [self setupPlaySound];
    [self playSoundWithData:songData];
}

// Added for play two songs simulatelly
- (void)playMixWithVoice:(NSData *)voiceData bgMusic:(NSURL *)bgMusic {
    [self setupPlaySound];
    
    NSError *bgError;
    _bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgMusic error:&bgError];
    _bgPlayer.volume = 1.0f;
    if (_bgPlayer == nil) {
        NSLog(@"Error creating bg Music player: %@", [bgError description]);
    }
    NSError *voiceError;
    _voicePlayer = [[AVAudioPlayer alloc] initWithData:voiceData error:&voiceError];
    _voicePlayer.volume = 1.0f;
    if (_voicePlayer == nil) {
        NSLog(@"Error creating bg Music player: %@", [voiceError description]);
    }

    _bgPlayer.delegate = self;
    [_bgPlayer play];
    
    _voicePlayer.delegate = self;
    [_voicePlayer play];
    [self.delegate UUAVAudioPlayerBeiginPlay];
    
}

-(void)playSoundWithData:(NSData *)soundData{
    if (_player) {
        [_player stop];
        _player.delegate = nil;
        _player = nil;
    }
    NSError *playerError;
    _player = [[AVAudioPlayer alloc]initWithData:soundData error:&playerError];
    _player.volume = 1.0f;
    if (_player == nil){
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    _player.delegate = self;
    [_player play];
    [self.delegate UUAVAudioPlayerBeiginPlay];
}

-(void)setupPlaySound{
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.delegate UUAVAudioPlayerDidFinishPlay];
}

- (void)stopSound
{
    if (_player && _player.isPlaying) {
        [_player stop];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [self.delegate UUAVAudioPlayerDidFinishPlay];
}

@end