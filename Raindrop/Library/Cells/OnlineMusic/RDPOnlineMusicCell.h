//
//  RDPOnlineMusicCell.h
//  Raindrop
//
//  Created by user on 16/1/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPOnlineMusicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (nonatomic, strong)NSString *mid;

- (IBAction)download:(id)sender;
@end
