//
//  RDPRecordCustomizeViewController.m
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordCustomizeViewController.h"
#import "RDPRecordMusicViewController.h"
#import "RDPRecordPhotoViewController.h"
#import "RDPMixAudioPlayer.h"
#import "RDPMixAudioMachine.h"

@interface RDPRecordCustomizeViewController ()

// Mix player for preview
@property (nonatomic, strong)RDPMixAudioPlayer *mixPlayer;

// Mix machine for output
@property (nonatomic, strong)RDPMixAudioMachine *mixMachine;

@property (nonatomic, strong)NSString *selectedBgMusic;
@property (nonatomic, strong)NSString *selectedPhoto;
@end

@implementation RDPRecordCustomizeViewController

@synthesize voiceData, selectedBgMusic, selectedPhoto;

- (void)viewDidLoad {
    // Initialize mix player
    self.selectedBgMusic = @"bird";
    _mixPlayer = [[RDPMixAudioPlayer alloc] init];
    [_mixPlayer playOcastraWithBgMusic:self.selectedBgMusic voice:self.voiceData];
    
    // Initialize mix machine
    _mixMachine = [[RDPMixAudioMachine alloc] init];
}


- (IBAction)upload:(id)sender {
    [_mixMachine mixAudioWithBgMusic:self.selectedBgMusic voice:self.voiceData];
}


- (IBAction)chooseMusic:(id)sender {
    [_mixPlayer stop];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RDPRecordMusicViewController *recordMusicController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RDPRecordMusicViewController"];
    recordMusicController.voiceData = self.voiceData;
    
    UINavigationController *recordNavigationController = [[UINavigationController alloc] initWithRootViewController:recordMusicController];
    [self.navigationController presentViewController:recordNavigationController animated:YES completion:nil];
}

// Go to choose photos
- (IBAction)choosePhoto:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RDPRecordPhotoViewController *recordPhotoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RDPRecordPhotoViewController"];
    
    UINavigationController *recordNavigationController = [[UINavigationController alloc] initWithRootViewController:recordPhotoController];
    [self.navigationController presentViewController:recordNavigationController animated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue
{
    NSLog(@"unwind from music");
    if ([segue.sourceViewController isKindOfClass:[RDPRecordMusicViewController class]]) {
        RDPRecordMusicViewController *sourceViewController = segue.sourceViewController;
        self.selectedBgMusic = sourceViewController.selectedBgMusic;
        NSLog(@"%@", self.selectedBgMusic);
    } else if([segue.sourceViewController isKindOfClass:[RDPRecordPhotoViewController class]]) {
        RDPRecordPhotoViewController *sourceViewController = segue.sourceViewController;
        self.selectedPhoto = sourceViewController.selectedPhoto;
        NSLog(@"%@", self.selectedPhoto);
    }
}


@end
