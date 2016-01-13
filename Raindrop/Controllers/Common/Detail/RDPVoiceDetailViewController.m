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
#import "RDPVoiceDownloader.h"
#import "MBProgressHUD.h"
#import "RDPSoundDownloader.h"
#import <AVFoundation/AVFoundation.h>

@interface RDPVoiceDetailViewController ()<UIScrollViewDelegate, RDPVoiceDownloaderDelegate, RDPVoiceDetailViewDelegate, AVAudioPlayerDelegate, RDPSoundDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;

@property (nonatomic, strong)NSMutableArray *detailViews;

// TEMP AudioPlayer
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property (nonatomic, strong)RDPSoundDownloader *soundDownloader;

@end

@implementation RDPVoiceDetailViewController

@synthesize contentView;
@synthesize dataSource, totalCount, currentIndex, currentCount, currentOffset;
@synthesize parentView;
@synthesize audioPlayer;
@synthesize soundDownloader;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Sound Downloader initliaze
    self.soundDownloader = [[RDPSoundDownloader alloc] init];
    self.soundDownloader.delegate = self;
    
    // ChildView
    NSMutableArray *childViews = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < totalCount; i++)
    {
        [childViews addObject:[NSNull null]];
    }
    self.detailViews = childViews;
    
    [self setupScrollViewWithCount:totalCount];
    [self loadContentViewAtIndex:currentIndex];
//    [self loadContentViewAtIndex:currentIndex + 1];
    
    //self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * currentIndex, 0.0f);
    NSLog(@"ContentOffset is : %f,%f", _scrollView.contentOffset.x, _scrollView.contentOffset.y);

//    [self.view setNeedsDisplay];
//    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {

    [_scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * currentIndex, 0.0f) animated:NO];
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
    if (index >= self.totalCount || index < 0)
        return;
    if (index >= self.dataSource.count) {
        NSLog(@"Need load more data from server");
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadRemoteHotVoiceWithOffset:self.currentOffset];
//        return;
    } else {
            [self refreshContentAtIndex:index];
    }
}

- (void)refreshContentAtIndex:(NSInteger)index {
    // Get data at index idx
    RDPHotModel *model = [self.dataSource objectAtIndex:index];
    
    // replace the placeholder if necessary
    RDPVoiceDetailView *childView = [self.detailViews objectAtIndex:index];
    if ((NSNull *)childView == [NSNull null])
    {
        childView = [[[NSBundle mainBundle] loadNibNamed:@"RDPVoiceDetailView" owner:nil options:nil] objectAtIndex:0];
        childView.delegate = self;
        [childView.photoView setImage:[UIImage imageNamed:model.imagePath]];
        [childView.heartnoLabel setText:model.score];
        [childView.descLabel setText:model.descText];
        [childView setVoiceName:model.voicePath];
        
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

- (void)loadRemoteHotVoiceWithOffset:(NSUInteger)offset {
    RDPVoiceDownloader *downloader = [[RDPVoiceDownloader alloc] init];
    downloader.delegate = self;
    NSDictionary *params = @{@"offset":[NSString stringWithFormat:@"%lu", (unsigned long)offset]};
    [downloader downloadVoiceDataWithParams:params];
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.currentIndex != page) {
        if (self.audioPlayer != nil) {
            [self.audioPlayer stop];
            [self stopAudioPlayer];
        }
    }
    currentIndex = page;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling);
    [self loadContentViewAtIndex:page];
//    [self loadContentViewAtIndex:page + 1];
    [self loadContentViewAtIndex:page - 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goBack:(id)sender {
    self.parentView.totalCount = self.totalCount;
    self.parentView.dataSource = self.dataSource;
    self.parentView.currentOffset = self.currentOffset;
    self.parentView.currentCount = self.currentCount;
    self.parentView.currentIndex = self.currentIndex;
    [self dismissViewControllerAnimated:YES completion:^{
//        [self.parentView.mainCollectionView reloadData];
        [self.parentView scrollToCellAtIndex:self.currentIndex];
    }];
}

#pragma mark - RDPVoiceDownloaderDelegate
- (void)voiceDownloader:(RDPVoiceDownloader *)downloader didDownloadSuccess:(id)data {
    NSLog(@"%@", data);
    NSDictionary *dict = (NSDictionary *)data;
    self.totalCount = [[dict objectForKey:@"total_count"] integerValue];
    
    
    if (self.totalCount > 0) {
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
            hot.cellHeight = (App_Frame_Width - 30)/2 + 10.0f + rect.size.height;
            [self.dataSource addObject:hot];
        }
        // Update offset
        self.currentOffset += 1;
        self.currentCount += array.count;
    }
    
    [self refreshContentAtIndex:self.currentIndex];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (CGRect)getTextHeight:(NSString *)inputText {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [inputText boundingRectWithSize:CGSizeMake((App_Frame_Width - 30)/2, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    return rect;
}

- (void)voiceDownloader:(RDPVoiceDownloader *)downloader didDownloadFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - RDPVoiceDetailViewDelegate
- (void)voiceDetailView:(RDPVoiceDetailView *)detailView playVoiceName:(NSString *)voiceName {
    NSLog(@"Clicked at voice : %@", voiceName);
    if (self.audioPlayer != nil) {
        if (self.audioPlayer.playing) {
            [self.audioPlayer stop];
            [self stopAudioPlayer];
        }
    } else {
        [self.soundDownloader downloadSoundWithVoiceName:voiceName];
    }
}

#pragma mark - RDPSoundDownloaderDelegate
- (void)soundDownloader:(RDPSoundDownloader *)downloader didDownloadSoundSuccess:(NSData *)soundData {
    NSLog(@"Download sound success");
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
    self.audioPlayer.delegate = self;
    if (error) {
        NSLog(@"Error creating audio player, %@", [error localizedDescription]);
    } else {
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    
}

- (void)soundDownloader:(RDPSoundDownloader *)downloader didDownloadSoundFail:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Audio Player Finished with Flag %d", flag);
    [self stopAudioPlayer];
}

- (void)stopAudioPlayer {
    self.audioPlayer.delegate = nil;
    self.audioPlayer = nil;
}

// TODO: Interruptions should be added here
@end
