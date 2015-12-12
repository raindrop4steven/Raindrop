//
//  MainViewController.m
//  Raindrop
//
//  Created by user on 15/12/10.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "MainViewController.h"
#import "PureLayout.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;

@property (assign, nonatomic) int totalPages;
@property (assign, nonatomic) NSUInteger currentPage;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView setPagingEnabled:YES];
    [self generatePages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generatePages {
    int count = 3;
    [self setupPages:count];
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
        UIView *childView = [[UIView alloc] initWithFrame:self.scrollView.frame];
        if (i == 1) {
            childView.backgroundColor = [UIColor redColor];
        } else if(i == 2) {
            childView.backgroundColor = [UIColor blueColor];
        } else {
            childView.backgroundColor = [UIColor purpleColor];
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollView delegate

- (void)scrollViewWillEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    page = MIN(MAX(page, 0), self.totalPages);
    self.currentPage = page;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.currentPage, 0.0);
}
@end
