//
//  RDPMixAudioPlayer.m
//  Raindrop
//
//  Created by user on 15/12/20.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPMixAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface RDPMixAudioPlayer ()<AVAudioPlayerDelegate>

// Voice Data
@property (nonatomic, strong)NSData *voiceData;
// Player
@property (nonatomic, strong)AVAudioPlayer *bgPlayer;
@property (nonatomic, strong)AVAudioPlayer *voicePlayer;
// NStimer
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation RDPMixAudioPlayer

@synthesize voiceData;

// Play background music
- (void)playBgMusic:(NSString *)bgMusicName {
    // Get Song Path
    NSString *str=[[NSBundle mainBundle] pathForResource:bgMusicName ofType:@"caf"];
    NSURL *bgURL = [NSURL fileURLWithPath:str];
    
    // Initliaze Audio Player
    NSError *bgError;
    _bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgURL error:&bgError];
    
    if (bgError) {
        // Fail Create Audio Player
        NSLog(@"Error create bgPlayer : %@", [bgError description]);
    } else {
        _bgPlayer.delegate = self;
        // Configure Audio Volume
        _bgPlayer.volume = 0.5f;
        [_bgPlayer prepareToPlay];
        [_bgPlayer play];
        NSLog(@"bgPlayer start playing");
    }
}

// Play my voice
- (void)playVoice {
    NSError *voiceError;
    _voicePlayer = [[AVAudioPlayer alloc] initWithData:self.voiceData error:&voiceError];
    
    if (voiceError) {
        NSLog(@"Error create voice Player : %@", [voiceError description]);
    } else {
        _voicePlayer.delegate = self;
        _voicePlayer.volume = 1.0f;
        [_voicePlayer prepareToPlay];
        [_voicePlayer play];
        NSLog(@"voicePlay playing");
    }
}

// Play bgMusic and myVoice after n s
- (void)playOcastraWithBgMusic:(NSString *)bgName voice:(NSData *)voice {
    // Play bg music first
    [self playBgMusic:bgName];
    
    self.voiceData = voice;
    
    // Play after 3.0 s
    CGFloat interval = 5.0f;
    
    // NSTimer
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(playVoice) userInfo:nil repeats:NO];
}

// Stop all the player
- (void)stop {
    // Gradually effect?
    
    [_bgPlayer stop];
    [_voicePlayer stop];
    _bgPlayer = nil;
    _voicePlayer = nil;
}
@end
