//
//  RDPRecordPhotoViewController.h
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPRecordPhotoViewController : UIViewController

@property (nonatomic, strong)NSString *selectedPhoto;

@property (weak, nonatomic) IBOutlet UICollectionView *phohtoCollectionView;
@end
