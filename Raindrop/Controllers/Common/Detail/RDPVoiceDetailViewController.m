//
//  RDPVoiceDetailViewController.m
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPVoiceDetailViewController.h"
#import "RDPVoiceDetailView.h"
#import "RDPHotModel.h"

@interface RDPVoiceDetailViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;

@property (nonatomic, strong)NSMutableArray *detailViews;

@end

@implementation RDPVoiceDetailViewController

@synthesize contentView;
@synthesize dataSource, totalCount, currentIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Generate random data
    [self generateRandomData];
    
    NSMutableArray *childViews = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < totalCount; i++)
    {
        [childViews addObject:[NSNull null]];
    }
    self.detailViews = childViews;
    
    [self setupScrollViewWithCount:totalCount];
    [self loadContentViewAtIndex:currentIndex];
    [self loadContentViewAtIndex:currentIndex + 1];
    
    //self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * currentIndex, 0.0f);
    NSLog(@"ContentOffset is : %f,%f", _scrollView.contentOffset.x, _scrollView.contentOffset.y);

//    [self.view setNeedsDisplay];
//    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    
    [UIView animateWithDuration:.25 animations:^{
        [_scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * currentIndex, 0.0f) animated:YES];
    }];

}

- (void)generateRandomData {
    // datasource
    self.dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 45; i++) {
        RDPHotModel *model = [[RDPHotModel alloc] init];
        model.imagePath = @"bg.jpg";
        model.descText = [NSString stringWithFormat:@"%ld", (long)i];
        model.voicePath = @"";
        model.score = @"1992";
        
        [self.dataSource addObject:model];
    }
    // totalCount
    self.totalCount = 100;
    // currentindex
    self.currentIndex = 24;
}


// Set up scroll view, including width and constraints
- (void)setupScrollViewWithCount:(NSInteger)count {
    //  Setup delegate
    _scrollView.delegate = self;
    CGRect rect = _scrollView.frame;
    rect.size.width = App_Frame_Width;
    rect.size.height = App_Frame_Height;
    _scrollView.frame = rect;
    
    // Set paging mode
    [_scrollView setPagingEnabled:YES];
    
    // Clean any existing subviews
    NSArray *subviews = self.contentView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_scrollView withMultiplier:count];
    
}

// Set up page at index idx
- (void)loadContentViewAtIndex:(NSInteger)index {
    if (index >= self.totalCount)
        return;
    if (index > self.dataSource.count) {
        NSLog(@"Need load more data from server");
        return;
    }
    
    // Get data at index idx
    RDPHotModel *model = [self.dataSource objectAtIndex:index];
    
    // replace the placeholder if necessary
    RDPVoiceDetailView *childView = [self.detailViews objectAtIndex:index];
    if ((NSNull *)childView == [NSNull null])
    {
        childView = [[[NSBundle mainBundle] loadNibNamed:@"RDPVoiceDetailView" owner:nil options:nil] objectAtIndex:0];
        [childView.photoView setImage:[UIImage imageNamed:model.imagePath]];
        [childView.heartnoLabel setText:model.score];
        [childView.descLabel setText:model.descText];
        
        [self.detailViews replaceObjectAtIndex:index withObject:childView];
    }
    
    // add the controller's view to the scroll view
    if (childView.superview == nil)
    {
        CGRect rect = childView.frame;
        rect.size.width = App_Frame_Width;
        rect.size.height = App_Frame_Height;
        childView.frame = rect;
        
        [self.contentView addSubview:childView];
        [childView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_scrollView];
        [childView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [childView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [childView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:CGRectGetWidth(_scrollView.frame) * index];
    }
    NSLog(@"Load childView at index : %ld", (long)index);
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentIndex = page;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling);
    [self loadContentViewAtIndex:page];
    [self loadContentViewAtIndex:page + 1];
    [self loadContentViewAtIndex:page - 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
