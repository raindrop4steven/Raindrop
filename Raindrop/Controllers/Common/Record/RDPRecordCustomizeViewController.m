//
//  RDPRecordCustomizeViewController.m
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordCustomizeViewController.h"
#import "UUAVAudioPlayer.h"

@interface RDPRecordCustomizeViewController ()<UUAVAudioPlayerDelegate>

@property(nonatomic, strong)UUAVAudioPlayer *player;
@property BOOL contentVoiceIsPlaying;

@end

@implementation RDPRecordCustomizeViewController

@synthesize voiceData;

- (void)viewDidLoad {
    // play our voice, of couse it's only for now,
    // later will automatically compose with background music
    //[self playSongWithData:self.voiceData];
    
    
    
#if 1
    // play song with bg music
    NSString *str=[[NSBundle mainBundle] pathForResource:@"bird" ofType:@"caf"];
    NSURL *bgURL = [NSURL fileURLWithPath:str];
    //NSData *bgmusic = [NSData dataWithContentsOfURL:bgURL];
    [self playSongWithVoice:self.voiceData bgMusic:bgURL];
#endif
}

// Play our voice
-(void)playSongWithData:(NSData *)data {
    _contentVoiceIsPlaying = YES;
    _player = [UUAVAudioPlayer sharedInstance];
    _player.delegate = self;
    [_player playSongWithData:data];
}

- (void)playSongWithVoice:(NSData *)data bgMusic:(NSURL *)music {
    _contentVoiceIsPlaying = YES;
    _player = [UUAVAudioPlayer sharedInstance];
    _player.delegate = self;
    [_player playMixWithVoice:data bgMusic:music];
}

#pragma mark - UUAVAudioPlayerDelegate
- (void)UUAVAudioPlayerBeiginLoadVoice {
    
}
- (void)UUAVAudioPlayerBeiginPlay {
    
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    _contentVoiceIsPlaying = NO;
    [[UUAVAudioPlayer sharedInstance]stopSound];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
