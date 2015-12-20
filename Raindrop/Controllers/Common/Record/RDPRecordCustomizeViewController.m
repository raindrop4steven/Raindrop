//
//  RDPRecordCustomizeViewController.m
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordCustomizeViewController.h"
#import "RDPMixAudioPlayer.h"

@interface RDPRecordCustomizeViewController ()

@property (nonatomic, strong)RDPMixAudioPlayer *mixPlayer;
@end

@implementation RDPRecordCustomizeViewController

@synthesize voiceData;

- (void)viewDidLoad {
    _mixPlayer = [[RDPMixAudioPlayer alloc] init];
    [_mixPlayer playOcastraWithBgMusic:@"bird" voice:self.voiceData];
}


- (IBAction)upload:(id)sender {
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
