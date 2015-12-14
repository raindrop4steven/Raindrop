//
//  RDPHotView.h
//  Raindrop
//
//  Created by user on 15/12/12.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPHotView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

- (id)initWithFrame:(CGRect)frame ParentController:(UIViewController *)parentController;

@end