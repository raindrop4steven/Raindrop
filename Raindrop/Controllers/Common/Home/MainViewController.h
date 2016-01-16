//
//  MainViewController.h
//  Raindrop
//
//  Created by user on 15/12/10.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *setting;

- (IBAction)clickSetting:(id)sender;
@end
