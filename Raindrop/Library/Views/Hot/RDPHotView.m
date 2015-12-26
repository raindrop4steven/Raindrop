//
//  RDPHotView.m
//  Raindrop
//
//  Created by user on 15/12/12.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPHotView.h"
#import "RDPHotCollectionViewCell.h"
#import "RDPVoiceDetailViewController.h"
#import "RDPHotModel.h"

static NSString *RDPHotViewCellIdentifier = @"RDPHotCollectionViewCellIdentifiter";
static NSUInteger All_Marin = 30;
static CGFloat cellFactor = 1.524;

@interface RDPHotView()

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, strong) UIViewController *parentController;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property NSInteger totalCount;

@end

@implementation RDPHotView

@synthesize mainCollectionView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    // 1. Caculate cell's width
    self.cellWidth = (App_Frame_Width - All_Marin)/2;
    
    // 2. Set up collectionView
    [self setupCollectionView];

    // 3. Generate datasource
    [self getDataSource];
    
    return self;
}

- (void)getDataSource {
    _totalCount = 45;
    
    _dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < _totalCount; i++) {
        RDPHotModel *hot = [[RDPHotModel alloc] init];
        hot.imagePath = @"bg.jpg";
        hot.descText = @"做一只文艺狗的日子是欢乐的做一只文艺狗的日子是欢乐的做一只文艺狗的日子是欢乐的做一只文艺狗的日子是欢乐的做一只文艺狗的日子是欢乐的做一只文艺狗的日子是欢乐的做一只文艺狗的日子是欢乐的";
        
        CGRect rect = [self getTextHeight:hot.descText];
        hot.cellHeight = self.cellWidth + 10.0f + rect.size.height;
        [_dataSource addObject:hot];
    }
    
    [self.mainCollectionView reloadItemsAtIndexPaths:[self.mainCollectionView indexPathsForVisibleItems]];
}

- (CGRect)getTextHeight:(NSString *)inputText {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [inputText boundingRectWithSize:CGSizeMake(self.cellWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    
    return rect;
}

- (id)initWithFrame:(CGRect)frame ParentController:(UIViewController *)parentController {
    self = [self initWithFrame:frame];
    self.parentController = parentController;
    
    return self;
}

// Initialize collection view
- (void)setupCollectionView {
    // 1. Initialize collectionViewFlowLayout
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth * cellFactor)];
    [flowlayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    [flowlayout setMinimumLineSpacing:10];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // 2. Initialize collection view
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowlayout];
    self.mainCollectionView.collectionViewLayout = flowlayout;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    [self.mainCollectionView setBackgroundColor:[UIColor raindropWhiteGreyBgColor]];
    
    // 3. Register our cell
    //[self.mainCollectionView registerClass:[RDPHotCollectionViewCell class] forCellWithReuseIdentifier:RDPHotViewCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"RDPHotCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:RDPHotViewCellIdentifier];
    
    // 4. Add our collection view to our view
    [self addSubview:self.mainCollectionView];
    
    [self.mainCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.mainCollectionView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.mainCollectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.mainCollectionView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. Get data at indexPath
    RDPHotModel *hot = [_dataSource objectAtIndex:[indexPath row]];
    
    // 2. Set up reuse identifer
    RDPHotCollectionViewCell *cell = (RDPHotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RDPHotViewCellIdentifier forIndexPath:indexPath];
    
    // 3. Check cell
    if (cell == nil) {
        cell = [[RDPHotCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellWidth * cellFactor)];
    }
    
    // 4. Setup contents
    [cell.bgImage setImage:[UIImage imageNamed:hot.imagePath]];
    [cell.desc setText:hot.descText];
    
    [cell layoutIfNeeded];
    //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RDPHotModel *hot = [_dataSource objectAtIndex:[indexPath row]];
    return CGSizeMake(self.cellWidth, hot.cellHeight);
}


#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Clicked at cell : %ld", (long)[indexPath row]);
    
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
    RDPVoiceDetailViewController *detailViewController = [secondStoryboard instantiateViewControllerWithIdentifier:@"RDPVoiceDetailViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [self.parentController presentViewController:navigationController animated:YES completion:nil];
}

@end
