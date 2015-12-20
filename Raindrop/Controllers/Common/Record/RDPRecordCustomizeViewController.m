//
//  RDPRecordCustomizeViewController.m
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordCustomizeViewController.h"
#import "RDPRecordMusicViewController.h"
#import "RDPMixAudioPlayer.h"
#import "RDPMixAudioMachine.h"

@interface RDPRecordCustomizeViewController ()

// Mix player for preview
@property (nonatomic, strong)RDPMixAudioPlayer *mixPlayer;

// Mix machine for output
@property (nonatomic, strong)RDPMixAudioMachine *mixMachine;

@end

@implementation RDPRecordCustomizeViewController

@synthesize voiceData;

- (void)viewDidLoad {
    // Initialize mix player
    _mixPlayer = [[RDPMixAudioPlayer alloc] init];
    [_mixPlayer playOcastraWithBgMusic:@"bird" voice:self.voiceData];
    
    // Initialize mix machine
    _mixMachine = [[RDPMixAudioMachine alloc] init];
}


- (IBAction)upload:(id)sender {
    [_mixMachine mixAudioWithBgMusic:@"bird" voice:self.voiceData];
}


- (IBAction)chooseMusic:(id)sender {
    [_mixPlayer stop];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RDPRecordMusicViewController *recordMusicController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RDPRecordMusicViewController"];
    recordMusicController.voiceData = self.voiceData;
    
    UINavigationController *recordNavigationController = [[UINavigationController alloc] initWithRootViewController:recordMusicController];
    [self.navigationController presentViewController:recordNavigationController animated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
