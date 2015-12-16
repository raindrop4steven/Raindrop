//
//  RDPRecordingViewController.m
//  Raindrop
//
//  Created by user on 15/12/14.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordingViewController.h"
#import "Mp3Recorder.h"

@interface RDPRecordingViewController ()<Mp3RecorderDelegate>

// record state
@property RDPRecordState recordState;
// Mp3
@property (nonatomic, strong)Mp3Recorder *mp3Recorder;
@property NSInteger playTime;
@property (nonatomic, strong) NSTimer *playTimer;

@end

@implementation RDPRecordingViewController

@synthesize username;
@synthesize recordingTime;

- (void)viewDidLoad {
    self.userLabel.text = self.username;
    // 1. Setup show image
    [self setUpHeadImage];
    // 2. Setup record button
    [self setUpRecordButton];
    // 3. Setup record state
    self.recordState = RDPRecordStateReady;
    [self setUpRecordStateWith: self.recordState];
}


// Setup round image
- (void)setUpHeadImage {
    // 1. Make it round
    CGFloat height = self.userImageView.frame.size.height;
    self.userImageView.layer.cornerRadius = height / 2;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.image = [UIImage imageNamed:@"user.png"];
}

// Setup record button
- (void)setUpRecordButton {
    // 1. Make rounded
    [self.MicBtn.layer setCornerRadius:64/2];
    [self.MicBtn.layer setMasksToBounds:YES];
    
    // 2. Add background image
    [self.MicBtn setTitle:@"" forState:UIControlStateNormal];
    [self.MicBtn setBackgroundColor:[UIColor raindropRedColor]];
    [self.MicBtn setImage:[UIImage imageNamed:@"mic.png"] forState:UIControlStateNormal];
    
    // 3. Add action selector
    [self.MicBtn addTarget:self action:@selector(controlRecord) forControlEvents:UIControlEventTouchUpInside];
}

// beginRecord
- (void)controlRecord{
    // Current ready, next recording
    if (self.recordState == RDPRecordStateReady) {
        // 1. Update state and icon state
        self.recordState = RDPRecordStateRecording;
        [self setUpRecordStateWith:self.recordState];
        // 2. Begin to record
        [self beginRecordVoice];
    } else if(self.recordState == RDPRecordStateRecording){
        self.recordState = RDPRecordStateStop;
        [self setUpRecordStateWith:self.recordState];
        // 2. stop record
        [self endRecordVoice];
    } else {
        // reset record
        [self resetRecord:nil];
    }
}

// Setup record state with given state
- (void)setUpRecordStateWith:(RDPRecordState )currentState {
    switch (currentState) {
        // currently is read, when pressed, it turned to be stoped.
        case RDPRecordStateReady:
            // 1. set button image as mic
            [self.MicBtn setImage:[UIImage imageNamed:@"mic.png"] forState:UIControlStateNormal];
            // 2. enable reset and next button
            [self.resetBtn setEnabled:YES];
            [self.nextBtn setEnabled:YES];
            // 3. update userlabel
            [self.userLabel setText:@"准备录制小刀的声音"];
            // 4. timelabel
            [self.recordingTime setText:@""];
            break;
        case RDPRecordStateRecording:
            // mic button icon chaged
            [self.MicBtn setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
            // disable reset and next button
            [self.resetBtn setEnabled:NO];
            [self.nextBtn setEnabled:NO];
            [self.userLabel setText:@"正在录制小刀的声音"];
            break;
        case RDPRecordStateStop:
            // 1. set button image as mic
            [self.MicBtn setImage:[UIImage imageNamed:@"mic.png"] forState:UIControlStateNormal];
            // 2. enable reset and next button
            [self.resetBtn setEnabled:YES];
            [self.nextBtn setEnabled:YES];
            // 3. update userlabel
            [self.userLabel setText:@"完成录制小刀的声音"];
        default:
            break;
    }
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice
{
    [_mp3Recorder startRecord];
    _playTime = 0;
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    //[UUProgressHUD show];
}

- (void)endRecordVoice
{
    if (_playTimer) {
        [_mp3Recorder stopRecord];
        [_playTimer invalidate];
        _playTimer = nil;
    }
}

// Count voice time, current max time is 60s
- (void)countVoiceTime
{
    _playTime ++;
    self.recordingTime.text = [NSString stringWithFormat:@"%ld",_playTime];
    if (_playTime>=60) {
        [self endRecordVoice];
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{

}

- (void)failRecord
{
#if 0
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
#endif
}

- (IBAction)resetRecord:(id)sender {
    // state
    self.recordState = RDPRecordStateReady;
    [self setUpRecordStateWith:self.recordState];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
