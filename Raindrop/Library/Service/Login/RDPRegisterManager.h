//
//  RDPRegisterManager.h
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDPRegisterManager;
@protocol RDPRegisterManagerDelegate <NSObject>

- (void)registerManager:(RDPRegisterManager *)manager didRegisterSuccess:(NSData *)data;
- (void)registerManager:(RDPRegisterManager *)manager didRegisterFailed:(NSError *)error;

@end


@interface RDPRegisterManager : NSObject

@property (nonatomic,weak)id<RDPRegisterManagerDelegate> delegate;

- (void)registerWithParams:(NSDictionary *)params;

+ (id)sharedManager;

@end
