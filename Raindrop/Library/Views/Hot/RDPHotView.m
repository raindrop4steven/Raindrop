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

@interface RDPHotView()

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) NSMutableArray *heightArray;
@end

@implementation RDPHotView

@synthesize mainCollectionView;

- (id)init {
    self = [super init];
    // array
    self.heightArray = [[NSMutableArray alloc] init];
    
    // Initialize collection view
    [self setupCollectionView];
    
    self.cellWidth = (App_Frame_Width - All_Marin)/2;
    
    return self;
}

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
    //[flowlayout setItemSize:CGSizeMake(self.cellWidth, 256)];
    [flowlayout setSectionInset:UIEdgeInsetsMake(12, 12, 12, 12)];
    [flowlayout setMinimumLineSpacing:10];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // 2. Initialize collection view
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:Application_Frame collectionViewLayout:flowlayout];
//    self.mainCollectionView = [UICollectionView new];
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
    NSLog(@"Cell");
    
    // 1. Register nib file for the cell
//    UINib *nib = [UINib nibWithNibName:@"RDPHotCollectionViewCell" bundle:[NSBundle mainBundle]];
//    [collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    
    // 2. Set up reuse identifer
    RDPHotCollectionViewCell *cell = (RDPHotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RDPHotViewCellIdentifier forIndexPath:indexPath];
    
    // 3. Check cell
    if (cell == nil) {
        cell = [[RDPHotCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 168, 256)];
    }
    
    // 4. Setup contents
    [cell.bgImage setImage:[UIImage imageNamed:@"bg.jpg"]];
    [cell.desc setText:@"这是一个测试, with some english"];
    [cell.heartno setText:@"30"];
    [cell.chatno setText:@"14"];
    [cell.bgImageHeight setConstant:172];
    
    NSNumber *num = [NSNumber numberWithFloat:cell.frame.size.height + [indexPath row] * 4];
    
    [self.heightArray addObject: num];
    
    [cell setNeedsDisplay];
    [cell layoutIfNeeded];
    
     [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"size");
    NSNumber *height = [self.heightArray objectAtIndex:[indexPath row]];
    return CGSizeMake(self.cellWidth, height.floatValue);
}


@end
