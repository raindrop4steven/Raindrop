//
//  RDPVoiceDetailView.h
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPVoiceDetailView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *heartnoLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatnoLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
