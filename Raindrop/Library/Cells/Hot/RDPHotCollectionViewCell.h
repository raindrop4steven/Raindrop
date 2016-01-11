//
//  RDPHotCollectionViewCell.h
//  Raindrop
//
//  Created by user on 15/12/12.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPHotCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceFromTop;

@end