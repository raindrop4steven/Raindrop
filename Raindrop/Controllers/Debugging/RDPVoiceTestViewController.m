//
//  RDPVoiceTestViewController.m
//  Raindrop
//
//  Created by user on 15/12/18.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPVoiceTestViewController.h"
#import "Mp3Recorder.h"
#import <AVFoundation/AVFoundation.h>

@interface RDPVoiceTestViewController ()<Mp3RecorderDelegate, AVAudioPlayerDelegate>

// Player
@property (nonatomic, strong)AVAudioPlayer *bgPlayer;
@property (nonatomic, strong)AVAudioPlayer *voicePlayer;

// Mp3
@property (nonatomic, strong)Mp3Recorder *mp3Recorder;

@property (nonatomic, strong)NSData *myVoice;

// NStimer
@property (nonatomic, strong)NSTimer *timer;

@property BOOL isRecording;

@end


@implementation RDPVoiceTestViewController

- (void)viewDidLoad {

    // Set button
    [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
    
    // Mp3 recorder
    _mp3Recorder = [[Mp3Recorder alloc] initWithDelegate:self];
    
    // Set IsRecording to be false
    _isRecording = NO;
}

// Play background music
- (void)playBgMusic {
    // Get Song Path
    NSString *str=[[NSBundle mainBundle] pathForResource:@"bird" ofType:@"caf"];
    NSURL *bgURL = [NSURL fileURLWithPath:str];
    
    // Initliaze Audio Player
    NSError *bgError;
    _bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgURL error:&bgError];
    
    if (bgError) {
        // Fail Create Audio Player
        NSLog(@"Error create bgPlayer : %@", [bgError description]);
    } else {
        _bgPlayer.delegate = self;
        // Configure Audio Volume
        _bgPlayer.volume = 0.5f;
        [_bgPlayer prepareToPlay];
        [_bgPlayer play];
        NSLog(@"bgPlayer start playing");
    }
}

// Play my voice
- (void)playVoice {
    NSError *voiceError;
    _voicePlayer = [[AVAudioPlayer alloc] initWithData:_myVoice error:&voiceError];
    
    if (voiceError) {
        NSLog(@"Error create voice Player : %@", [voiceError description]);
    } else {
        _voicePlayer.delegate = self;
        _voicePlayer.volume = 1.0f;
        [_voicePlayer prepareToPlay];
        [_voicePlayer play];
        NSLog(@"voicePlay playing");
    }
}

// Slider change action
- (IBAction)sliderDidChanged:(id)sender {
    NSLog(@"slider changed");
    
    // Get Slider Value
    CGFloat volume = self.slider.value;
    
    if (_bgPlayer != nil) {
        self.volume.text = [NSString stringWithFormat:@"%f", volume];
        _bgPlayer.volume = volume;
    }
}

// Play bgMusic and myVoice after n s
- (void)playOcastra {
    // Play bg music first
    [self playBgMusic];
    
    // Play after 3.0 s
    CGFloat interval = 5.0f;
    
    // NSTimer
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(playVoice) userInfo:nil repeats:NO];
}


#pragma mark - 录音touch事件
- (void)endRecordVoice
{
    [_mp3Recorder stopRecord];
    // Set button
    [self.recordButton setTitle:@"录音完成" forState:UIControlStateNormal];
}

- (void)beginRecordVoice
{
    [_mp3Recorder startRecord];
    // Set button
    [self.recordButton setTitle:@"正在录音" forState:UIControlStateNormal];
}

// Record action
- (IBAction)record:(id)sender {
    if (_isRecording) {
        // Stop
        [self endRecordVoice];
    } else {
        // Start
        _isRecording = YES;
        [self beginRecordVoice];
    }
}

// Mix bgMusic and voice data
- (IBAction)mixAudio:(id)sender {
    [self.mixButton setTitle:@"Mixing..." forState:UIControlStateNormal];
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
    NSString *str=[[NSBundle mainBundle] pathForResource:@"bird" ofType:@"caf"];
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
    [_myVoice writeToFile:voicePath options:NSAtomicWrite error:&writeError];
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
#if 0
        for (int i = 0; i < [tracksToDuck count]; i++) {
            AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:[tracksToDuck objectAtIndex:i]];
            [trackMix setVolume:volume atTime:kCMTimeZero];
            [trackMixArray addObject:trackMix];
        }
#endif
        // 背景音乐音轨参数设置
        AVMutableAudioMixInputParameters *bgTrackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:[tracksToDuck objectAtIndex:0]];
        [bgTrackMix setVolume:1.0f atTime:kCMTimeZero];
        [bgTrackMix setVolumeRampFromStartVolume:1.0f toEndVolume:0.4f timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(5.0f, 600), CMTimeMakeWithSeconds(8.0f, 699))];
        [trackMixArray addObject:bgTrackMix];
        
        // 声音参数设置，不大
        AVMutableAudioMixInputParameters *voiceTrackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:[tracksToDuck objectAtIndex:1]];
        [voiceTrackMix setVolume:1.0f atTime:kCMTimeZero];
        [trackMixArray addObject:voiceTrackMix];
        
        // 参数汇总
        audioMix.inputParameters = trackMixArray;
        
        /************** Step 4 : Export Merged Audio File ************/
        NSString *mixedPath = [documentsDir stringByAppendingPathComponent:@"mix.m4a"];
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

#pragma mark - MP3Delegate
- (void)endConvertWithData:(NSData *)voiceData {
    _myVoice = voiceData;
    //[self playOcastra];
}

- (void)beginConvert {
    
}

- (void)failRecord {
    
}
@end
