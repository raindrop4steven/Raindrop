//
//  RDPProfileView.h
//  Raindrop
//
//  Created by user on 15/12/23.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPProfileView : UIView

@property (nonatomic, strong)UIImageView *headView;
@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UITableView *profileTableView;


- (id)initWithFrame:(CGRect)frame ParentController:(UIViewController *)parentController;
@end
