//
//  RDPVoiceDetailView.h
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDPVoiceDetailView;
@protocol RDPVoiceDetailViewDelegate <NSObject>

- (void)voiceDetailView:(RDPVoiceDetailView*)detailView playVoiceName:(NSString*)voiceName;
- (void)voiceDetailView:(RDPVoiceDetailView *)detailView givePrizeType:(NSString *)prizeType;

@end


@interface RDPVoiceDetailView : UIView

@property(nonatomic, weak)id<RDPVoiceDetailViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *heartnoLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;

@property (nonatomic, strong)NSString *voiceName;
@property (nonatomic, strong)NSString *vid;

- (IBAction)playVoice:(id)sender;
- (IBAction)clickPlus:(id)sender;
- (IBAction)clickMinus:(id)sender;
@end
