//
//  RDPRegisterViewController.h
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPRegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


- (IBAction)register:(id)sender;
- (IBAction)goBack:(id)sender;
@end
