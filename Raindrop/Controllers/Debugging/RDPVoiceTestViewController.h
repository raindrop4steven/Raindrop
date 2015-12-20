//
//  RDPVoiceTestViewController.h
//  Raindrop
//
//  Created by user on 15/12/18.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPVoiceTestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *mixButton;


- (IBAction)sliderDidChanged:(id)sender;
- (IBAction)record:(id)sender;
- (IBAction)mixAudio:(id)sender;
@end
