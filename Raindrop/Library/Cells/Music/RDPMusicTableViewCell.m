//
//  RDPMusicTableViewCell.m
//  Raindrop
//
//  Created by user on 15/12/20.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPMusicTableViewCell.h"

@implementation RDPMusicTableViewCell

@synthesize songImageView, songName;
@synthesize playButton, checkButton;
@synthesize songId, delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self playMixAudio:nil];
}

- (IBAction)playMixAudio:(id)sender {
    if ([self.delegate respondsToSelector:@selector(RDPMusicCell:playButtonPressed:)]) {
        [self.delegate RDPMusicCell:self playButtonPressed:self.playButton];
    }
}

- (IBAction)checkIt:(id)sender {
    if ([self.delegate respondsToSelector:@selector(RDPMusicCell:CheckButtonPressed:)]) {
        [self.delegate RDPMusicCell:self CheckButtonPressed:self.checkButton];
    }
}
@end