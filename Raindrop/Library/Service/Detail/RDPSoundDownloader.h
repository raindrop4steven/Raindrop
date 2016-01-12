//
//  RDPSoundDownloader.h
//  Raindrop
//
//  Created by user on 16/1/12.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDPSoundDownloader;
@protocol RDPSoundDownloaderDelegate <NSObject>

- (void)soundDownloader:(RDPSoundDownloader*)downloader didDownloadSoundSuccess:(NSData *)soundData;
- (void)soundDownloader:(RDPSoundDownloader *)downloader didDownloadSoundFail:(NSError *)error;

@end

@interface RDPSoundDownloader : NSObject

@property (nonatomic, strong)id<RDPSoundDownloaderDelegate> delegate;

- (void)downloadSoundWithVoiceName:(NSString *)voiceName;
@end
