//
//  RDPVoiceDetailViewController.m
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPVoiceDetailViewController.h"
#import "RDPVoiceDetailView.h"

@interface RDPVoiceDetailViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (assign, nonatomic) NSUInteger totalPages;
@property (assign, nonatomic) NSUInteger currentPage;
@end

@implementation RDPVoiceDetailViewController

@synthesize scrollView, contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. Setup delegate
    self.scrollView.delegate = self;
    
    // 2. Update title
    self.currentPage = 0;
    
    // 3. Set up scrollview
    [self.scrollView setPagingEnabled:YES];
    [self generatePages];
    
    
    
#if 0
    RDPVoiceDetailView *detail = [[[NSBundle mainBundle] loadNibNamed:@"RDPVoiceDetailView" owner:nil options:nil] objectAtIndex:0];
    
    [self.contentview addSubview:detail];
    
    [detail autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [detail autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [detail autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [detail autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    // Do any additional setup after loading the view.
#endif
}

- (void)generatePages {
    [self setupPages:3];
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
        RDPVoiceDetailView *childView = [[[NSBundle mainBundle] loadNibNamed:@"RDPVoiceDetailView" owner:nil options:nil] objectAtIndex:0];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
