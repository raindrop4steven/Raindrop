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
#import "RDPVoiceDownloader.h"
#import "RDPHotModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *RDPHotViewCellIdentifier = @"RDPHotCollectionViewCellIdentifiter";
static NSUInteger All_Marin = 30;
static CGFloat cellFactor = 1.524;

@interface RDPHotView()<RDPVoiceDownloaderDelegate>

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, strong) UIViewController *parentController;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign)NSUInteger currentOffset;
@property (nonatomic, assign)NSUInteger currentCount;
@property NSInteger totalCount;

@end

@implementation RDPHotView

@synthesize mainCollectionView;
@synthesize currentOffset, currentCount;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    // 0. Initialize based variables
    _dataSource = [[NSMutableArray alloc] init];
    // offset to be 1
    self.currentOffset = 1;
    // current count 0
    self.currentCount = 0;
    
    // 1. Caculate cell's width
    self.cellWidth = (App_Frame_Width - All_Marin)/2;
    
    // 2. Set up collectionView
    [self setupCollectionView];
    
    // Set up MJRefresh
    [self setMJRefresh];

    // 3. Generate datasource
    //[self getDataSource];
    [self loadRemoteHotVoiceWithOffset:self.currentOffset];
    return self;
}

- (void)setMJRefresh {
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    self.mainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"Pull down to refresh");
        [weakSelf reloadVoiceData];
    }];
    
    self.mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"pull up to load more");
        [weakSelf loadMore];
    }];
}

// Reload data
- (void)reloadVoiceData {
    [_dataSource removeAllObjects];
    self.totalCount = 0;
    self.currentCount = 0;
    self.currentOffset = 1;
    [self loadRemoteHotVoiceWithOffset:self.currentOffset];
}

// Load more from server
- (void)loadMore {
    if (self.currentCount < self.totalCount)
        [self loadRemoteHotVoiceWithOffset:self.currentOffset];
    else {
        [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)loadRemoteHotVoiceWithOffset:(NSUInteger)offset {
    RDPVoiceDownloader *downloader = [[RDPVoiceDownloader alloc] init];
    downloader.delegate = self;
    NSDictionary *params = @{@"offset":[NSString stringWithFormat:@"%lu", (unsigned long)offset]};
    [downloader downloadVoiceDataWithParams:params];
}

#if 0
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
#endif

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
    //[flowlayout setMinimumLineSpacing:10];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // 2. Initialize collection view
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowlayout];
    self.mainCollectionView.collectionViewLayout = flowlayout;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    [self.mainCollectionView setBackgroundColor:[UIColor raindropWhiteGreyBgColor]];
    self.mainCollectionView.alwaysBounceVertical = YES;
    
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
    //[cell.bgImage setImage:[UIImage imageNamed:hot.imagePath]];
    [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.88.1:5000/static/%@", hot.imagePath]]];
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
    detailViewController.dataSource = _dataSource;
    detailViewController.totalCount = self.totalCount;
    detailViewController.currentIndex = [indexPath row];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [self.parentController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - RDPVoiceDownloaderDelegate
- (void)voiceDownloader:(RDPVoiceDownloader *)downloader didDownloadSuccess:(id)data {
    NSLog(@"%@", data);
    NSDictionary *dict = (NSDictionary *)data;
    _totalCount = [[dict objectForKey:@"total_count"] integerValue];
    
    
    if (_totalCount > 0) {
        NSMutableArray *array = [dict objectForKey:@"voice_list"];
        
        for (int i = 0; i < array.count; i++) {
            NSDictionary *voiceData = (NSDictionary *)[array objectAtIndex:i];
            RDPHotModel *hot = [[RDPHotModel alloc] init];
            hot.voice_id = [voiceData objectForKey:@"vid"];
            hot.user_id = [voiceData objectForKey:@"uid"];
            hot.voicePath = [voiceData objectForKey:@"voice"];
            hot.imagePath = [voiceData objectForKey:@"image"];
            hot.descText = [voiceData objectForKey:@"desc"];
            hot.score = [voiceData objectForKey:@"score"];
            CGRect rect = [self getTextHeight:hot.descText];
            hot.cellHeight = self.cellWidth + 10.0f + rect.size.height;
            [_dataSource addObject:hot];
        }
        // Update offset
        self.currentOffset += 1;
        self.currentCount += array.count;
    }
    
    // [self.mainCollectionView reloadItemsAtIndexPaths:[self.mainCollectionView indexPathsForVisibleItems]];
    [self.mainCollectionView reloadData];
    
    [self.mainCollectionView.mj_header endRefreshing];
    
    [self.mainCollectionView.mj_footer endRefreshing];
    
}

- (void)voiceDownloader:(RDPVoiceDownloader *)downloader didDownloadFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

@end
