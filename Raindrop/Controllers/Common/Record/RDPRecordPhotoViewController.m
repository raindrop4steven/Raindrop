//
//  RDPRecordPhotoViewController.m
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordPhotoViewController.h"
#import "RDPPhotoCollectionViewCell.h"
#import "RDPPhoto.h"

static NSString *RDPRecordPhotoViewIdentifier = @"RDPPhotoCollectionViewCell";

@interface RDPRecordPhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation RDPRecordPhotoViewController

@synthesize phohtoCollectionView;

- (void)viewDidLoad {
    // 1. datasource
    _dataSource = [[NSMutableArray alloc] init];
    [self setupPhotoSource];
    
    [self setupPhohtoCollectionView];
}

- (void)setupPhotoSource {
    for (int i = 0; i < 57; i++) {
        RDPPhoto *photo = [[RDPPhoto alloc] init];
        
        if (i % 2 == 0) {
            photo.photoName = @"sunset.jpg";
        } else {
            photo.photoName = @"dog.jpg";
        }
        
        [_dataSource addObject:photo];
    }
}

- (void)setupPhohtoCollectionView {
    // 1. set delegate
    self.phohtoCollectionView.delegate = self;
    self.phohtoCollectionView.dataSource = self;
    
    // 2. set apparence
    self.phohtoCollectionView.backgroundColor = [UIColor raindropWhiteGreyBgColor];
    
    // 2. Register cell
    UINib *nib = [UINib nibWithNibName:@"RDPPhotoCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.phohtoCollectionView registerNib:nib forCellWithReuseIdentifier:RDPRecordPhotoViewIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. Get photo data
    RDPPhoto *photo = [_dataSource objectAtIndex:[indexPath row]];

    // 2. Set up reuse identifer
    RDPPhotoCollectionViewCell *cell = (RDPPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RDPRecordPhotoViewIdentifier forIndexPath:indexPath];
    
    // 3. Check cell
    if (cell == nil) {
        NSLog(@"come into nil");
    }
    
    [cell.albumImage setImage:[UIImage imageNamed:photo.photoName]];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RDPPhoto *photoInfo = [_dataSource objectAtIndex:[indexPath row]];
    self.selectedPhoto = photoInfo.photoName;
    NSLog(@"%@", self.selectedPhoto);
}
@end
