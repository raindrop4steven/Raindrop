//
//  RDPHotFlowLayout.h
//  Raindrop
//
//  Created by user on 15/12/13.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPHotFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign)CGFloat columnMargin;

@property (nonatomic, assign)CGFloat rowMargin;

@property (nonatomic, assign)NSInteger columnCount;

@property (nonatomic, assign)UIEdgeInsets sectionInset;

@end
