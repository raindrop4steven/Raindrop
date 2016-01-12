//
//  RDPVoiceDetailView.m
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPVoiceDetailView.h"

@implementation RDPVoiceDetailView

@synthesize photoView, heartnoLabel, playButton, descLabel;
@synthesize voiceName;
@synthesize delegate;


// Play our voice
- (IBAction)playVoice:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceDetailView:playVoiceName:)]) {
        [self.delegate voiceDetailView:self playVoiceName:self.voiceName];
    }
}
@end
