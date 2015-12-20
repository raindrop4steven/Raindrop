//
//  RDPRecordCustomizeViewController.m
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordCustomizeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RDPRecordCustomizeViewController ()<AVAudioPlayerDelegate>

// Player
@property (nonatomic, strong)AVAudioPlayer *bgPlayer;
@property (nonatomic, strong)AVAudioPlayer *voicePlayer;
// NStimer
@property (nonatomic, strong)NSTimer *timer;

@property BOOL contentVoiceIsPlaying;

@end

@implementation RDPRecordCustomizeViewController

@synthesize voiceData;

- (void)viewDidLoad {
    [self playOcastra];
}

// Play background music
- (void)playBgMusic {
    // Get Song Path
    NSString *str=[[NSBundle mainBundle] pathForResource:@"bird" ofType:@"caf"];
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
- (void)playOcastra {
    // Play bg music first
    [self playBgMusic];
    
    // Play after 3.0 s
    CGFloat interval = 5.0f;
    
    // NSTimer
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(playVoice) userInfo:nil repeats:NO];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
