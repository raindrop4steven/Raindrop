//
//  RDPSoundDownloader.m
//  Raindrop
//
//  Created by user on 16/1/12.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPSoundDownloader.h"

@implementation RDPSoundDownloader

@synthesize delegate;

- (void)downloadSoundWithVoiceName:(NSString *)voiceName {
    NSString *filename = voiceName;
    NSError *error = nil;
    NSDictionary *params = nil;
    // Get Cache Path and File Path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"];
    NSString *filePath = [diskCachePath stringByAppendingPathComponent:filename];
    
    // Check if file exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // File already exists
        NSData *audioData = [NSData dataWithContentsOfFile:filePath];
        if ([self.delegate respondsToSelector:@selector(soundDownloader:didDownloadSoundSuccess:)]) {
            [self.delegate soundDownloader:self didDownloadSoundSuccess:audioData];
        }
    } else {
        // Check if directory exists
        // If not, create new one
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        
        // Report error if Voice Cache directory created failed
        if (error) {
            if ([self.delegate respondsToSelector:@selector(soundDownloader:didDownloadSoundFail:)]) {
                [self.delegate soundDownloader:self didDownloadSoundFail:error];
            }
        } else {
            // Directory Created Success, Begin to download voice data
            // Query URL
            NSString *queryURL = [NSString stringWithFormat:@"%@/%@", @"http://192.168.88.1:5000/voices", voiceName];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            // Add authenticate later
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            // Add m4a to accept content types
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"audio/m4a"];
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"steven" password:@"hello"];
            
            [manager GET:queryURL
              parameters:params
                progress:^(NSProgress * _Nonnull downloadProgress) {
                    NSLog(@"%@", [downloadProgress localizedDescription]);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    NSData *audio = (NSData *)responseObject;
                    [[NSFileManager defaultManager] createFileAtPath:filePath contents:responseObject attributes:nil];
                    
                    if ([self.delegate respondsToSelector:@selector(soundDownloader:didDownloadSoundSuccess:)]) {
                        [self.delegate soundDownloader:self didDownloadSoundSuccess:responseObject];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if ([self.delegate respondsToSelector:@selector(soundDownloader:didDownloadSoundFail:)]) {
                        [self.delegate soundDownloader:self didDownloadSoundFail:error];
                    }
                }];
            
        }
    }
}
@end
