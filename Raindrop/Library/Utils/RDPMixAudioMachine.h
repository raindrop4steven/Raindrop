//
//  RDPMixAudioMachine.h
//  Raindrop
//
//  Created by user on 15/12/20.
//  Copyright © 2015年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPMixAudioMachine : NSObject

- (void)mixAudioWithBgMusic:(NSString *)bgName voice:(NSData *)voice;

@end
