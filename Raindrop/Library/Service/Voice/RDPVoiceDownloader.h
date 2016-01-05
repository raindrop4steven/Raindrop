//
//  RDPVoiceDownloader.h
//  Raindrop
//
//  Created by user on 16/1/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDPVoiceDownloader;

@protocol RDPVoiceDownloaderDelegate <NSObject>

- (void)voiceDownloader:(RDPVoiceDownloader *)downloader didDownloadSuccess:(id)data;
- (void)voiceDownloader:(RDPVoiceDownloader *)downloader didDownloadFailed:(NSError *)error;

@end

@interface RDPVoiceDownloader : NSObject

@property (nonatomic, weak)id<RDPVoiceDownloaderDelegate> delegate;

+ (id)sharedInstance;

- (void)downloadVoiceDataWithParams:(NSDictionary *)params;
- (void)downloadVoiceData;

@end
