//
//  RDPHotView.m
//  Raindrop
//
//  Created by user on 15/12/12.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPHotView.h"
#import "RDPHotCollectionViewCell.h"

static NSString *RDPHotViewCellIdentifier = @"RDPHotCollectionViewCellIdentifiter";
static NSUInteger All_Marin = 38;
static CGFloat imageFactor = 1.023f;
static CGFloat cellFactor = 1.524;

@interface RDPHotView()

@property (nonatomic, assign) CGFloat cellWidth;

@end

@implementation RDPHotView

@synthesize mainCollectionView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.cellWidth = (App_Frame_Width - All_Marin)/2;
    [self setupCollectionView];
    
    return self;
}
// Initialize collection view
- (void)setupCollectionView {
    // 1. Initialize collectionViewFlowLayout
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth * cellFactor)];
    [flowlayout setSectionInset:UIEdgeInsetsMake(12, 12, 12, 12)];
    [flowlayout setMinimumLineSpacing:10];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // 2. Initialize collection view
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:Application_Frame collectionViewLayout:flowlayout];
    self.mainCollectionView.collectionViewLayout = flowlayout;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    [self.mainCollectionView setBackgroundColor:[UIColor blueColor]];
    
    // 3. Register our cell
    //[self.mainCollectionView registerClass:[RDPHotCollectionViewCell class] forCellWithReuseIdentifier:RDPHotViewCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"RDPHotCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:RDPHotViewCellIdentifier];
    
    // 4. Add our collection view to our view
    [self addSubview:self.mainCollectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 45;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. Register nib file for the cell
//    UINib *nib = [UINib nibWithNibName:@"RDPHotCollectionViewCell" bundle:[NSBundle mainBundle]];
//    [collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    
    // 2. Set up reuse identifer
    RDPHotCollectionViewCell *cell = (RDPHotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RDPHotViewCellIdentifier forIndexPath:indexPath];
    
    // 3. Check cell
    if (cell == nil) {
        cell = [[RDPHotCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellWidth * cellFactor)];
    }
    
    // 4. Setup contents
    [cell.bgImage setImage:[UIImage imageNamed:@"bg.jpg"]];
    [cell.desc setText:@"这是一个测试, with some english"];
    [cell.heartno setText:@"30"];
    [cell.chatno setText:@"14"];
    [cell.bgImageHeight setConstant:self.cellWidth * imageFactor];

    // 5. Setup button size
    [cell.heartBtn setTitle:@"" forState:UIControlStateNormal];
    [cell.chatBtn setTitle:@"" forState:UIControlStateNormal];
    
    CGSize btnSize = CGSizeMake(15, 14);
    
    CGRect oldFrame = [cell.heartBtn frame];
    oldFrame.size = btnSize;
    [cell.heartBtn setFrame:oldFrame];
    [cell.heartBtn setBackgroundImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];

    oldFrame = [cell.chatBtn frame];
    oldFrame.size = btnSize;
    [cell.chatBtn setFrame:oldFrame];
    [cell.chatBtn setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    
    // 6. Setup description
//    [cell setNeedsDisplay];
//    [cell layoutIfNeeded];
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.cellWidth, 256+15);
//}


@end
