//
//  RDPHotModel.h
//  Raindrop
//
//  Created by user on 15/12/26.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPHotModel : NSObject

@property (nonatomic, strong)NSString *imagePath;
@property (nonatomic, strong)NSString *descText;
@property (nonatomic, strong)NSString *voicePath;
@property (nonatomic, strong)NSString *score;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *voice_id;

@property CGFloat cellHeight;

@end
