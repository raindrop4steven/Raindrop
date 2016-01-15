//
//  ResMusic+CoreDataProperties.h
//  Raindrop
//
//  Created by user on 16/1/15.
//  Copyright © 2016年 steven. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ResMusic.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResMusic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
