//
//  MainViewController.m
//  Raindrop
//
//  Created by user on 15/12/10.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "MainViewController.h"
#import "PureLayout.h"
#import "RDPRecordMotionViewController.h"
#import "RDPHotView.h"
#import "RDPNearView.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (assign, nonatomic) NSUInteger totalPages;
@property (assign, nonatomic) NSUInteger currentPage;

@property (strong, nonatomic) UILabel *hotLabel;
@property (strong, nonatomic) UILabel *nearLabel;
@property (strong, nonatomic) UILabel *myLabel;

@property (strong, nonatomic)NSMutableArray *faceViews;
@end

@implementation MainViewController

@synthesize faceViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. Setup delegate
    self.scrollView.delegate = self;
    // 1. Setup titleView
    [self setupTitleView];
    
    // 2. Update title
    self.currentPage = 0;
    [self updateTitleWithcurrentPage:self.currentPage];
    
    // 3. Setup record button
    [self setupRecordButton];
    
    // 4. faceviews
    self.faceViews = [[NSMutableArray alloc] init];
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
//    [self setupPages:3];
    RDPHotView *hotView = [[RDPHotView alloc] initWithFrame:self.scrollView.frame ParentController:self];
    RDPNearView *nearView = [[RDPNearView alloc] initWithFrame:self.scrollView.frame ParentController:self];
    RDPNearView *nearView2 = [[RDPNearView alloc] initWithFrame:self.scrollView.frame ParentController:self];
    [self.faceViews addObject:hotView];
    [self.faceViews addObject:nearView];
    [self.faceViews addObject:nearView2];
    
    [self setupPages:self.faceViews];
}

// Setup record button
- (void)setupRecordButton {
    // 1. Initiliaze a round button
    UIButton *recordButton = [UIButton new];
    
    // 2. Make it float
    [self.view addSubview:recordButton];
    [self.view bringSubviewToFront:recordButton];
    
    // 3. Adjust positon
    [recordButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:27];
    [recordButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // 4. Make rounded
    [recordButton autoSetDimensionsToSize:CGSizeMake(45, 45)];
    [recordButton.layer setCornerRadius:45/2];
    [recordButton.layer setMasksToBounds:YES];
    
    // 5. Add background image
    [recordButton setBackgroundColor:[UIColor raindropBlueColor]];
    [recordButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    
    // 6. Add action selector
    [recordButton addTarget:self action:@selector(chooseMotion) forControlEvents:UIControlEventTouchUpInside];
    
}

// Show up choose motion viewcontroller
- (void)chooseMotion {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RDPRecordMotionViewController *recordMotionController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RDPRecordMotionViewController"];
    UINavigationController *recordNavigationController = [[UINavigationController alloc] initWithRootViewController:recordMotionController];
    [self.navigationController presentViewController:recordNavigationController animated:YES completion:nil];
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

- (void)setupPages:(NSMutableArray *)viewArrays {
    NSInteger pages = viewArrays.count;
    self.totalPages = pages;
    
    // Clean any existing subviews
    NSArray *subviews = self.contentView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:pages];
    UIView *childView = nil;
    UIView *preChild = nil;
    for (int i = 0; i < pages; i++) {
        childView = [viewArrays objectAtIndex:i];

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
