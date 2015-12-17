//
//  UUAVAudioPlayer.h
//  BloodSugarForDoc
//
//  Created by shake on 14-9-1.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@protocol UUAVAudioPlayerDelegate <NSObject>

@optional
- (void)UUAVAudioPlayerBeiginLoadVoice;
- (void)UUAVAudioPlayerBeiginPlay;
@required
- (void)UUAVAudioPlayerDidFinishPlay;

@end

@interface UUAVAudioPlayer : NSObject
@property (nonatomic ,strong)  AVAudioPlayer *player;
@property (nonatomic, assign)id <UUAVAudioPlayerDelegate>delegate;

+ (UUAVAudioPlayer *)sharedInstance;
-(void)playSongWithUrl:(NSString *)songUrl;

-(void)playSongWithData:(NSData *)songData;
- (void)playMixWithVoice:(NSData *)voiceData bgMusic:(NSURL *)bgMusic;

- (void)stopSound;
@end
