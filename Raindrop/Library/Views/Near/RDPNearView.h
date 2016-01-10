//
//  RDPNearView.h
//  Raindrop
//
//  Created by user on 15/12/12.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPNearView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

- (id)initWithFrame:(CGRect)frame ParentController:(UIViewController *)parentController;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign)NSUInteger currentOffset;
@property (nonatomic, assign)NSUInteger currentCount;
@property (nonatomic, assign)NSUInteger currentIndex;
@property NSInteger totalCount;

- (void)scrollToCellAtIndex:(NSUInteger)index;
@end