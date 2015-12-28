//
//  RDPVoiceDetailViewController.h
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RDPVoiceDetailViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, assign)NSInteger totalCount;

- (IBAction)goBack:(id)sender;
@end
