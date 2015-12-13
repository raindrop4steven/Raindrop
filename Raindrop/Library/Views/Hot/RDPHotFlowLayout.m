//
//  RDPHotFlowLayout.m
//  Raindrop
//
//  Created by user on 15/12/13.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPHotFlowLayout.h"

@implementation RDPHotFlowLayout

- (instancetype)init {
    if (self == [super init]) {
        self.columnCount = 2;
        self.columnMargin = 12;
        self.rowMargin = 12;
        self.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    }
    
    return self;
}
@end
