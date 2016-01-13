//
//  RDPTokenManager.m
//  Raindrop
//
//  Created by user on 16/1/13.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPTokenManager.h"

@implementation RDPTokenManager

@synthesize delegate;

+ (id)sharedManager {
    static RDPTokenManager *manager = nil;
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

- (void)getTokenWithParams:(NSDictionary *)params {
    NSString *username = [params objectForKey:@"username"];
    NSString *password = [params objectForKey:@"password"];
    
    NSString *queryURL = @"http://192.168.88.1:5000/api/token";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    [manager GET:queryURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dict = (NSDictionary *)responseObject;
             if ([self.delegate respondsToSelector:@selector(tokenManager:didGetTokenSuccess:)]) {
                 [self.delegate tokenManager:self didGetTokenSuccess:dict];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if ([self.delegate respondsToSelector:@selector(tokenManager:didGetTokenFailed:)]) {
                 [self.delegate tokenManager:self didGetTokenFailed:error];
             }
         }];
}
@end