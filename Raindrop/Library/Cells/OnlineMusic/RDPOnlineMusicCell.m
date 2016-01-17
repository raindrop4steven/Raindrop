//
//  RDPOnlineMusicCell.m
//  Raindrop
//
//  Created by user on 16/1/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPOnlineMusicCell.h"

@implementation RDPOnlineMusicCell

@synthesize albumView, songNameLabel, introductionLabel, downloadButton, mid;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)download:(id)sender {
}
@end
