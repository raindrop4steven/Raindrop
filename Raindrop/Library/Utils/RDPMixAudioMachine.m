//
//  RDPMixAudioMachine.m
//  Raindrop
//
//  Created by user on 15/12/20.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPMixAudioMachine.h"
#import <AVFoundation/AVFoundation.h>

@interface RDPMixAudioMachine ()

@property (nonatomic, strong)NSData *voiceData;
@property (nonatomic, strong)NSString *bgMusic;

@end

@implementation RDPMixAudioMachine


- (void)mixAudioWithBgMusic:(NSString *)bgName voice:(NSData *)voice {
    NSLog(@"Mixing...");
    /************** Step 1 : Create AVMutableComposition + AVMutableCompositionTracks ************/
    // AudioMutableComposition
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // Background Music Track
    AVMutableCompositionTrack *mutableCompBgTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // User's Voice
    AVMutableCompositionTrack *mutableCompVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    /************** Step 2 : Convert Audio Files To AVSAssets ************/
    CMTime currentCMTime = kCMTimeZero;
    
    // Add Background Music First
    // Get Song Path
    NSString *str=[[NSBundle mainBundle] pathForResource:bgName ofType:@"caf"];
    NSURL *bgURL = [NSURL fileURLWithPath:str];
    // Create Background Music Assert
    AVAsset *bgAssert = [AVAsset assetWithURL:bgURL];
    [mutableCompBgTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, bgAssert.duration)
                                ofTrack:[[bgAssert tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                 atTime:currentCMTime
                                  error:nil];
    // Create Voice Assert
    NSString *documentsDir = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *voicePath = [documentsDir stringByAppendingPathComponent:@"voice.caf"];
    
    // Write Voice Data To Disk
    NSError *writeError;
    [voice writeToFile:voicePath options:NSAtomicWrite error:&writeError];
    if (writeError) {
        NSLog(@"Write Error : %@", [writeError description]);
    } else {
        NSURL *voiceURL = [NSURL fileURLWithPath:voicePath];
        // Avoice Assert
        AVAsset *voiceAssert = [AVAsset assetWithURL:voiceURL];
        
        NSArray *tracks = [voiceAssert tracksWithMediaType:AVMediaTypeAudio];
        
        // Crate Voice Assert
        NSError *voiceError;
        [mutableCompVoiceTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, voiceAssert .duration)
                                       ofTrack:[[voiceAssert tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                        atTime:currentCMTime
                                         error:&voiceError];
        NSLog(@"Error Make Voice Track : %@", [voiceError description]);
        
        currentCMTime = CMTimeAdd(currentCMTime, bgAssert.duration);
        
        /************** Step 3 : Mix Audio ************/
        // 获取composition中的tracks，对每个tracks进行参数设置，获得audioMix，用来在转换时赋给exportAsset。
        NSArray *tracksToDuck = [mixComposition tracksWithMediaType:AVMediaTypeAudio];
        // 获取混音器
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        //
        NSMutableArray *trackMixArray = [NSMutableArray array];
        
        // 背景音乐音轨参数设置
        AVMutableAudioMixInputParameters *bgTrackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:[tracksToDuck objectAtIndex:0]];
        [bgTrackMix setVolume:1.0f atTime:kCMTimeZero];
        [bgTrackMix setVolumeRampFromStartVolume:1.0f toEndVolume:0.4f timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(5.0f, 600), CMTimeMakeWithSeconds(8.0f, 600))];
        [trackMixArray addObject:bgTrackMix];
        
        // 声音参数设置，不大
        AVMutableAudioMixInputParameters *voiceTrackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:[tracksToDuck objectAtIndex:1]];
        [voiceTrackMix setVolume:1.0f atTime:kCMTimeZero];
        [trackMixArray addObject:voiceTrackMix];
        
        // 参数汇总
        audioMix.inputParameters = trackMixArray;
        
        /************** Step 4 : Export Merged Audio File ************/
        NSString *mixedPath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"mix-%d.m4a",arc4random() % 1000]];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
        exportSession.outputFileType = AVFileTypeAppleM4A;
        exportSession.outputURL = [NSURL fileURLWithPath:mixedPath];
        // Track Mix arg
        exportSession.audioMix = audioMix;
        
        CMTimeValue val = mixComposition.duration.value;
        CMTime start = CMTimeMake(0, 1);
        CMTime duration = CMTimeMake(val, 1);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    NSLog(@"Export failed: %@ %@", [[exportSession error] localizedDescription],[[exportSession error]debugDescription]);
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog(@"Export canceled");
                    break;
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"Export complete!");
                    NSLog(@"%@", exportSession.outputURL);
                    break;
                }
                default:
                {
                    NSLog(@"default");
                    break;
                }
            }
        }];
    }
}

@end
