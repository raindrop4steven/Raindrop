//
//  RDPRecordMotionViewController.h
//  Raindrop
//
//  Created by user on 15/12/14.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPRecordMotionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (weak, nonatomic) IBOutlet UIImageView *clockView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedMotion;
@property (weak, nonatomic) IBOutlet UIButton *laughBtn;
@property (weak, nonatomic) IBOutlet UIButton *happyBtn;
@property (weak, nonatomic) IBOutlet UIButton *surpriseBtn;
@property (weak, nonatomic) IBOutlet UIButton *sadBtn;
@property (weak, nonatomic) IBOutlet UIButton *angryBtn;

- (IBAction)goback:(id)sender;
- (IBAction)laugh:(id)sender;
- (IBAction)happy:(id)sender;
- (IBAction)surprise:(id)sender;
- (IBAction)angry:(id)sender;
- (IBAction)sad:(id)sender;

@end
