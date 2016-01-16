//
//  RDPNearView.m
//  Raindrop
//
//  Created by user on 15/12/12.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPNearView.h"
#import "RDPHotCollectionViewCell.h"
#import "RDPVoiceDetailViewController.h"
#import "RDPVoiceDownloader.h"
#import "RDPNearModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static NSString *RDPNearViewCellIdentifier = @"RDPHotCollectionViewCellIdentifiter";
static NSUInteger All_Marin = 30;
static CGFloat cellFactor = 1.524;

@interface RDPNearView()<RDPVoiceDownloaderDelegate, CLLocationManagerDelegate>

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, strong) UIViewController *parentController;

// Location Manger
@property (nonatomic, strong)CLLocationManager *locationManager;

@property (nonatomic, strong)NSString *longitute;
@property (nonatomic, strong)NSString *latitude;
@end

@implementation RDPNearView

@synthesize mainCollectionView;
@synthesize currentOffset, currentCount, currentIndex;
@synthesize longitute, latitude;

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

    // Ask for location
    // Location Manger
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self askForLocation];

    return self;
}

- (void)askForLocation {
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
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
    self.mainCollectionView.mj_footer.automaticallyHidden = YES;
}

// Reload data
- (void)reloadVoiceData {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [_dataSource removeAllObjects];
    self.totalCount = 0;
    self.currentCount = 0;
    self.currentOffset = 1;
    [self loadRemoteNearVoiceWithOffset:self.currentOffset];
}

// Load more from server
- (void)loadMore {
    if (self.currentCount < self.totalCount)
        [self loadRemoteNearVoiceWithOffset:self.currentOffset];
    else {
        [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)loadRemoteNearVoiceWithOffset:(NSUInteger)offset {
    RDPVoiceDownloader *downloader = [[RDPVoiceDownloader alloc] init];
    downloader.delegate = self;
    NSDictionary *params = @{@"offset":[NSString stringWithFormat:@"%lu", (unsigned long)offset], @"queryType":@"near", @"longitude":self.longitute, @"latitude":self.latitude};
    [downloader downloadVoiceDataWithParams:params];
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
    UINib *nib = [UINib nibWithNibName:@"RDPHotCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:RDPNearViewCellIdentifier];
    
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
    RDPNearModel *near = [_dataSource objectAtIndex:[indexPath row]];
    
    // 2. Set up reuse identifer
    RDPHotCollectionViewCell *cell = (RDPHotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RDPNearViewCellIdentifier forIndexPath:indexPath];
    
    // 3. Check cell
    if (cell == nil) {
        cell = [[RDPHotCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellWidth * cellFactor)];
    }
    
    // 4. Setup contents
    [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.88.1:5000/static/%@", near.imagePath]]];
    [cell.desc setText:near.descText];
    [cell.distance setText:near.distance];
    [cell.distanceFromTop setConstant:self.cellWidth - 20];
    
    [cell layoutIfNeeded];
    //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RDPNearModel *near = [_dataSource objectAtIndex:[indexPath row]];
    return CGSizeMake(self.cellWidth, near.cellHeight);
}


#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Clicked at cell : %ld", (long)[indexPath row]);
    
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
    RDPVoiceDetailViewController *detailViewController = [secondStoryboard instantiateViewControllerWithIdentifier:@"RDPVoiceDetailViewController"];
    // Current loaded data source
    detailViewController.dataSource = _dataSource;
    // All the record count
    detailViewController.totalCount = self.totalCount;
    // Current Tapped index
    detailViewController.currentIndex = [indexPath row];
    // Current loaded count
    detailViewController.currentCount = self.currentCount;
    // offset
    detailViewController.currentOffset = self.currentOffset;
    // set seft to detail's parent view
    detailViewController.parentView = self;
    detailViewController.resourceType = @"near";
    
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
            RDPNearModel *near = [[RDPNearModel alloc] init];
            near.voice_id = [voiceData objectForKey:@"vid"];
            near.user_id = [voiceData objectForKey:@"uid"];
            near.voicePath = [voiceData objectForKey:@"voice"];
            near.imagePath = [voiceData objectForKey:@"image"];
            near.descText = [voiceData objectForKey:@"desc"];
            near.score = [voiceData objectForKey:@"score"];
            near.distance = [voiceData objectForKey:@"distance"];
            CGRect rect = [self getTextHeight:near.descText];
            near.cellHeight = self.cellWidth + 10.0f + rect.size.height;
            [_dataSource addObject:near];
        }
        // Update offset
        self.currentOffset += 1;
        self.currentCount += array.count;
        
        // Hide HUD Progress
        [MBProgressHUD hideHUDForView:self animated:YES];
    }
    
    // [self.mainCollectionView reloadItemsAtIndexPaths:[self.mainCollectionView indexPathsForVisibleItems]];
    [self.mainCollectionView reloadData];
    
    [self.mainCollectionView.mj_header endRefreshing];
    
    [self.mainCollectionView.mj_footer endRefreshing];
    
}

- (void)voiceDownloader:(RDPVoiceDownloader *)downloader didDownloadFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

- (void)scrollToCellAtIndex:(NSUInteger)index {
    [self.mainCollectionView reloadData];
    [self.mainCollectionView layoutIfNeeded];

    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

#pragma mark - CLLocationManagerDelegatge
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitute = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(@"longitude : %@, latitude : %@", self.longitute, self.latitude);
    }
    
    // stop track location
    [manager stopUpdatingLocation];
    
    [self reloadVoiceData];
}
@end
