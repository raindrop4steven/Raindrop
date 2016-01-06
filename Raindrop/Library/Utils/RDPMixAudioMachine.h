//
//  RDPMixAudioMachine.h
//  Raindrop
//
//  Created by user on 15/12/20.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDPMixAudioMachine;
@protocol RDPMixAudioMachineDelegate <NSObject>

- (void)mixAudioMachine:(RDPMixAudioMachine *)machine didMixSuccess:(NSData *)data;
- (void)mixAudioMachine:(RDPMixAudioMachine *)machine didMixFailed:(NSError *)error;

@end

@interface RDPMixAudioMachine : NSObject

@property (nonatomic, weak)id<RDPMixAudioMachineDelegate> delegate;

- (void)mixAudioWithBgMusic:(NSString *)bgName voice:(NSData *)voice;

@end
