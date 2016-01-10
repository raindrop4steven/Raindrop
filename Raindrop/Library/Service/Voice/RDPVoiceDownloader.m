//
//  RDPVoiceDownloader.m
//  Raindrop
//
//  Created by user on 16/1/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPVoiceDownloader.h"

@implementation RDPVoiceDownloader

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
    NSString *queryType = [params objectForKey:@"queryType"];
    // Currently only allow "hot" and "near", should use NSENum instead
    NSString *queryURL = [NSString stringWithFormat:@"%@/%@", @"http://192.168.88.1:5000/voices", queryType];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"steven" password:@"hello"];
    
    [manager GET:queryURL
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
