//
//  RDPRecordMusicViewController.h
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPRecordMusicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSData *voiceData;
@property (weak, nonatomic) IBOutlet UITableView *songTableView;

@end