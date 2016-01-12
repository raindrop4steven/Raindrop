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

@end


@interface RDPVoiceDetailView : UIView

@property(nonatomic, weak)id<RDPVoiceDetailViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *heartnoLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong)NSString *voiceName;

- (IBAction)playVoice:(id)sender;
@end
