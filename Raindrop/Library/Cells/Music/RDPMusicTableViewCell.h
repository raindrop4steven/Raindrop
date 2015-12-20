//
//  RDPMusicTableViewCell.h
//  Raindrop
//
//  Created by user on 15/12/20.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDPMusicTableViewCell;

@protocol RDPMusicTableCellDelegate <NSObject>

- (void)RDPMusicCell:(RDPMusicTableViewCell *)cell playButtonPressed:(UIButton *)button;
- (void)RDPMusicCell:(RDPMusicTableViewCell *)cell CheckButtonPressed:(UIButton *)button;

@end

@interface RDPMusicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic)id<RDPMusicTableCellDelegate> delegate;
@property (nonatomic, strong) NSString *songName;
@property NSUInteger songId;

- (IBAction)playMixAudio:(id)sender;
- (IBAction)checkIt:(id)sender;
@end
