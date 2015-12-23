//
//  RDPProfileView.m
//  Raindrop
//
//  Created by user on 15/12/23.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPProfileView.h"
#import "PureLayout.h"

@interface RDPProfileView ()

@property (nonatomic, strong)UIView *topBarView;
@property (nonatomic, strong) UIViewController *parentController;

@end

@implementation RDPProfileView

@synthesize headView, nameLabel, profileTableView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Set up tableview
        [self setupTableView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame ParentController:(UIViewController *)parentController {
    self = [self initWithFrame:frame];
    self.parentController = parentController;
    
    return self;
}

// Set Up Table View
- (void)setupTableView {
    self.profileTableView = [[UITableView alloc] init];
    [self addSubview:self.profileTableView];
    [self.profileTableView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.profileTableView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.profileTableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.profileTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
}

@end
