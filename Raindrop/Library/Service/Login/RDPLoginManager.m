//
//  RDPLoginManager.m
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPLoginManager.h"

@implementation RDPLoginManager

@synthesize delegate;

+ (id)sharedManager {
    static RDPLoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)loginWithParams:(NSDictionary *)params {
    // Get username and password
    NSString *username = [params objectForKey:@"username"];
    NSString *password = [params objectForKey:@"password"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    [manager GET:@"http://192.168.88.1:5000/api/token"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([self.delegate respondsToSelector:@selector(loginManager:didLoginSuccess:)]) {
                 [self.delegate loginManager:self didLoginSuccess:responseObject];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if ([self.delegate respondsToSelector:@selector(loginManager:didLoginFailed:)]) {
                 [self.delegate loginManager:self didLoginFailed:error];
             }
         }];
}

@end
