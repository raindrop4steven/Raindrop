//
//  RDPVoiceDetailViewController.h
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPHotView.h"

@interface RDPVoiceDetailViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, assign)NSInteger totalCount;
@property (nonatomic, assign)NSUInteger currentCount;
@property (nonatomic, assign)NSUInteger currentOffset;

@property (nonatomic, strong)NSString *resourceType;

@property (nonatomic, weak)RDPHotView *parentView;

- (IBAction)goBack:(id)sender;
@end
