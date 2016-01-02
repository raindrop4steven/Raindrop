//
//  RDPRegisterManager.m
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPRegisterManager.h"

@implementation RDPRegisterManager

@synthesize delegate;

+ (id)sharedManager {
    static RDPRegisterManager *manager = nil;
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

- (void)registerWithParams:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://192.168.88.1:5000/api/users"
       parameters:params constructingBodyWithBlock:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([self.delegate respondsToSelector:@selector(registerManager:didRegisterSuccess:)]) {
                  [self.delegate registerManager:self didRegisterSuccess:responseObject];
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if ([self.delegate respondsToSelector:@selector(registerManager:didRegisterFailed:)]) {
                  [self.delegate registerManager:self didRegisterFailed:error];
              }
          }];
}
@end
