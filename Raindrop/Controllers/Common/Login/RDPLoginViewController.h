//
//  RDPLoginViewController.h
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *inputEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


- (IBAction)login:(id)sender;
@end
