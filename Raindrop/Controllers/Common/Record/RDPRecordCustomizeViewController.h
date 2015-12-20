//
//  RDPRecordCustomizeViewController.h
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPRecordCustomizeViewController : UIViewController

@property (nonatomic, strong)NSData *voiceData;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
- (IBAction)goBack:(id)sender;
- (IBAction)upload:(id)sender;
@end
