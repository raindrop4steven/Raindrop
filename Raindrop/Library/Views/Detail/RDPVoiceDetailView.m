//
//  RDPVoiceDetailView.m
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPVoiceDetailView.h"
#import "AppDelegate.h"
#import "PrizeRecord.h"

@implementation RDPVoiceDetailView

@synthesize photoView, heartnoLabel, playButton, descLabel;
@synthesize voiceName, vid;
@synthesize delegate;


// Play our voice
- (IBAction)playVoice:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceDetailView:playVoiceName:)]) {
        [self.delegate voiceDetailView:self playVoiceName:self.voiceName];
    }
}

- (IBAction)clickPlus:(id)sender {
    [self dealWithPrize:@"PLUS"];
    if ([self.delegate respondsToSelector:@selector(voiceDetailView:givePrizeType:)]) {
        [self.delegate voiceDetailView:self givePrizeType:@"PLUS"];
    }
}

- (IBAction)clickMinus:(id)sender {
    [self dealWithPrize:@"MINUS"];
    if ([self.delegate respondsToSelector:@selector(voiceDetailView:givePrizeType:)]) {
        [self.delegate voiceDetailView:self givePrizeType:@"MINUS"];
    }
}


- (void)dealWithPrize:(NSString *)prizeType {
    // Get ApplicationDelegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get Context
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    // First query for existing
    NSFetchRequest *fetch = [[NSFetchRequest alloc ]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PrizeRecord"
                                              inManagedObjectContext:context];
    [fetch setEntity:entity];
    
    NSInteger queryId = [self.vid integerValue];
    NSInteger score = [self.heartnoLabel.text integerValue];
    
    // Use Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vid == %@", [NSNumber numberWithInteger:queryId]];
    [fetch setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:fetch error:&error];
    
    if ([results count] > 0) {
        NSLog(@"Query that record");
    } else {
        NSLog(@"Not Query that record");
        
        // Show immediately change first
        if ([prizeType isEqualToString:@"PLUS"]) {
            [self.heartnoLabel setText:[NSString stringWithFormat:@"%ld", (score + 1)]];
        } else if (score > 0) {
            [self.heartnoLabel setText:[NSString stringWithFormat:@"%ld", (score - 1)]];
        }
        
        // New Records
        PrizeRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"PrizeRecord" inManagedObjectContext:context];
        
        [record setVid:[NSNumber numberWithInteger:[self.vid integerValue]]];
        
        // Begin to save record
        
        if (![context save:&error]) {
            NSLog(@"Save record failed\n %@", [error localizedDescription]);
        }
        
        // Send prize reqeust to server
        [self prizeVoice:self.vid type:prizeType];
    }
}

- (void)prizeVoice:(NSString *)voiceId type:(NSString *)prizeType {
    // Get weak type of self
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"steven" password:@"hello"];

    NSDictionary *params = @{@"voice_id":voiceId, @"prizeType":prizeType};
    
    [manager POST:@"http://192.168.88.1:5000/voices/prize"
       parameters:params constructingBodyWithBlock:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"%@", responseObject);
              NSDictionary *dict = (NSDictionary *)responseObject;
              NSString *score = [dict objectForKey:@"score"];
              [weakSelf.heartnoLabel setText:score];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@", [error localizedDescription]);
       }];
}
@end
