//
//  RDPTokenManager.h
//  Raindrop
//
//  Created by user on 16/1/13.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDPTokenManager;
@protocol RDPTokenManagerDelegate <NSObject>

- (void)tokenManager:(RDPTokenManager *)manager didGetTokenSuccess:(NSDictionary *)dict;
- (void)tokenManager:(RDPTokenManager *)manager didGetTokenFailed:(NSError *)error;

@end

@interface RDPTokenManager : NSObject

@property (nonatomic, weak)id<RDPTokenManagerDelegate> delegate;

+ (id)sharedManager;
- (void)getTokenWithParams:(NSDictionary *)params;

@end
