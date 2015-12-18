//
//  RDPVoiceTestViewController.m
//  Raindrop
//
//  Created by user on 15/12/18.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPVoiceTestViewController.h"
#import "Mp3Recorder.h"
#import <AVFoundation/AVFoundation.h>

@interface RDPVoiceTestViewController ()<Mp3RecorderDelegate, AVAudioPlayerDelegate>

// Player
@property (nonatomic, strong)AVAudioPlayer *bgPlayer;
@property (nonatomic, strong)AVAudioPlayer *voicePlayer;

// Mp3
@property (nonatomic, strong)Mp3Recorder *mp3Recorder;

@property (nonatomic, strong)NSData *myVoice;

// NStimer
@property (nonatomic, strong)NSTimer *timer;

@property BOOL isRecording;

@end


@implementation RDPVoiceTestViewController

- (void)viewDidLoad {

    // Set button
    [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
    
    // Mp3 recorder
    _mp3Recorder = [[Mp3Recorder alloc] initWithDelegate:self];
    
    // Set IsRecording to be false
    _isRecording = NO;
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
    _voicePlayer = [[AVAudioPlayer alloc] initWithData:_myVoice error:&voiceError];
    
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

// Slider change action
- (IBAction)sliderDidChanged:(id)sender {
    NSLog(@"slider changed");
    
    // Get Slider Value
    CGFloat volume = self.slider.value;
    
    if (_bgPlayer != nil) {
        self.volume.text = [NSString stringWithFormat:@"%f", volume];
        _bgPlayer.volume = volume;
    }
}

// Play bgMusic and myVoice after n s
- (void)playOcastra {
#if 1
    // Play bg music first
    [self playBgMusic];
    
    // Play after 3.0 s
    CGFloat interval = 5.0f;
    
    // NSTimer
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(playVoice) userInfo:nil repeats:NO];
#endif
}


#pragma mark - 录音touch事件
- (void)endRecordVoice
{
    [_mp3Recorder stopRecord];
    // Set button
    [self.recordButton setTitle:@"录音完成" forState:UIControlStateNormal];
}

- (void)beginRecordVoice
{
    [_mp3Recorder startRecord];
    // Set button
    [self.recordButton setTitle:@"正在录音" forState:UIControlStateNormal];
}

// Record action
- (IBAction)record:(id)sender {
    if (_isRecording) {
        // Stop
        [self endRecordVoice];
    } else {
        // Start
        _isRecording = YES;
        [self beginRecordVoice];
    }
}

#pragma mark - MP3Delegate
- (void)endConvertWithData:(NSData *)voiceData {
    _myVoice = voiceData;
    [self playOcastra];
}

- (void)beginConvert {
    
}

- (void)failRecord {
    
}
@end
