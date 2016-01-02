//
//  RDPLoginManager.h
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDPLoginManager;
@protocol RDPLoginManagerDelegate<NSObject>

- (void)loginManager:(RDPLoginManager *)manager didLoginSuccess:(NSData *)data;
- (void)loginManager:(RDPLoginManager *)manager didLoginFailed:(NSError *)error;

@end

@interface RDPLoginManager : NSObject

@property (nonatomic, weak) id<RDPLoginManagerDelegate> delegate;

- (void)loginWithParams:(NSDictionary *)params;
// Shared Manager for Login and Register
+ (id)sharedManager;

@end