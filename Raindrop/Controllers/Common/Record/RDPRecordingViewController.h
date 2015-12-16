//
//  RDPRecordingViewController.h
//  Raindrop
//
//  Created by user on 15/12/14.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RDPRecordState) {
    RDPRecordStateReady      = 0 , // Ready
    RDPRecordStateRecording  = 1 , // On recording
    RDPRecordStateStop       = 2   // Stop
};

@interface RDPRecordingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordingTime;
@property (weak, nonatomic) IBOutlet UIButton *MicBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) NSString *username;

- (IBAction)resetRecord:(id)sender;
- (IBAction)goback:(id)sender;


@end
