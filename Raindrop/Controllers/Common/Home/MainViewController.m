//
//  MainViewController.m
//  Raindrop
//
//  Created by user on 15/12/10.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "MainViewController.h"
#import "PureLayout.h"
#import "RDPHotView.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (assign, nonatomic) NSUInteger totalPages;
@property (assign, nonatomic) NSUInteger currentPage;

@property (strong, nonatomic) UILabel *hotLabel;
@property (strong, nonatomic) UILabel *nearLabel;
@property (strong, nonatomic) UILabel *myLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. Setup delegate
    self.scrollView.delegate = self;
    // 1. Setup titleView
    [self setupTitleView];
    
    // 2. Update title
    self.currentPage = 0;
    [self updateTitleWithcurrentPage:self.currentPage];
    
    // Do any additional setup after loading the view.
    [self.scrollView setPagingEnabled:YES];
    [self generatePages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitleView {
    // 1. Setup titleView
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width * 0.384, 17.5)];
    [self.navigationItem setTitleView:titleView];
    
    // 2. Setup our labels
    self.hotLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.hotLabel setText:@"热门"];
    [self.hotLabel layoutIfNeeded];
    [titleView addSubview:self.hotLabel];
    
    self.nearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.nearLabel setText:@"附近"];
    [self.nearLabel layoutIfNeeded];
    [titleView addSubview:self.nearLabel];
    
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.myLabel setText:@"我的"];
    [self.myLabel layoutIfNeeded];
    [titleView addSubview:self.myLabel];
    // 3. Setup contraints
    [self.hotLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.hotLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.myLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.myLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.nearLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.nearLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)generatePages {
    [self setupPages:3];
}

- (void)updateTitleWithcurrentPage:(NSUInteger)num {
    switch (num) {
        case 0:
            [self.hotLabel setTextColor:[UIColor raindropBlueColor]];
            [self.nearLabel setTextColor:[UIColor raindropBlackFontColor]];
            [self.myLabel setTextColor:[UIColor raindropBlackFontColor]];
            break;
            
        case 1:
            [self.nearLabel setTextColor:[UIColor raindropBlueColor]];
            [self.hotLabel setTextColor:[UIColor raindropBlackFontColor]];
            [self.myLabel setTextColor:[UIColor raindropBlackFontColor]];
            break;
            
        case 2:
            [self.myLabel setTextColor:[UIColor raindropBlueColor]];
            [self.hotLabel setTextColor:[UIColor raindropBlackFontColor]];
            [self.nearLabel setTextColor:[UIColor raindropBlackFontColor]];
            break;
            
        default:
            break;
    }
}

- (void)setupPages:(int)pages {
    self.totalPages = pages;
    
    // Clean any existing subviews
    NSArray *subviews = self.contentView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:pages];
    
    UIView *preChild = nil;
    for (int i = 0; i < pages; i++) {
        RDPHotView *childView = [[RDPHotView alloc] initWithFrame:self.scrollView.frame];
        [childView setBackgroundColor:[UIColor grayColor]];

        [self.contentView addSubview:childView];
        
        [childView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
        [childView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [childView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        if (!preChild) {
            // First childView will align to contentView
            [childView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        } else {
            // Subsequent childviews just align to its previous one
            [childView autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:preChild];
        }
        
        if (i == pages - 1) {
            // Last page will align to right edge
            [childView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        }
        
        preChild = childView;
    }
    
    self.scrollView.contentOffset = CGPointZero;
    
    [self.view setNeedsDisplay];
    [self.view layoutIfNeeded];
}

#if 0
// Set up subviews with array of viewcontrollers
- (void)setupContentWith:(NSArray *)controllerArray {
    NSUInteger pages = [controllerArray count];
    self.totalPages = pages;
    
    // Clean any existing subviews
    NSArray *subviews = self.contentView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:pages];
    UIView *preChild = nil;
    for (int i = 0; i < pages; i++) {
        RDPHotViewController *hotViewController = [controllerArray objectAtIndex:i];
        
        UIView *childView = hotViewController.view;
        
        [self.contentView addSubview:childView];
        
        [childView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
        [childView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [childView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        if (!preChild) {
            // First childView will align to contentView
            [childView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        } else {
            // Subsequent childviews just align to its previous one
            [childView autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:preChild];
        }
        
        if (i == pages - 1) {
            // Last page will align to right edge
            [childView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        }
        
        preChild = childView;
    }
    
    self.scrollView.contentOffset = CGPointZero;
    
    [self.view setNeedsDisplay];
    [self.view layoutIfNeeded];
}

#endif
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollView delegate

/* not used
- (void)scrollViewWillEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    page = MIN(MAX(page, 0), self.totalPages);
    self.currentPage = page;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.currentPage, 0.0);
}
*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    page = MIN(MAX(page, 0), self.totalPages);
    self.currentPage = page;
    [self updateTitleWithcurrentPage:self.currentPage];
}
@end
