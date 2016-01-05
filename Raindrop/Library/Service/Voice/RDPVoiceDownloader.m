//
//  RDPVoiceDownloader.m
//  Raindrop
//
//  Created by user on 16/1/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPVoiceDownloader.h"

@implementation RDPVoiceDownloader

+ (id)sharedInstance {
    static RDPVoiceDownloader *manager = nil;
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

- (void)downloadVoiceData {
    [self downloadVoiceDataWithParams:nil];
}

- (void)downloadVoiceDataWithParams:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"steven" password:@"hello"];
    
    [manager GET:@"http://192.168.88.1:5000/voices/hot"
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([self.delegate respondsToSelector:@selector(voiceDownloader:didDownloadSuccess:)]) {
                 [self.delegate voiceDownloader:self didDownloadSuccess:responseObject];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if ([self.delegate respondsToSelector:@selector(voiceDownloader:didDownloadFailed:)]) {
                 [self.delegate voiceDownloader:self didDownloadFailed:error];
             }
         }];
}

@end
