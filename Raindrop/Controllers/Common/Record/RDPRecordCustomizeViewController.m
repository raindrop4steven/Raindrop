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

@interface RDPRecordCustomizeViewController ()<RDPMixAudioMachineDelegate>

// Mix player for preview
@property (nonatomic, strong)RDPMixAudioPlayer *mixPlayer;

// Mix machine for output
@property (nonatomic, strong)RDPMixAudioMachine *mixMachine;

@property (nonatomic, strong)NSString *selectedBgMusic;
@property (nonatomic, strong)NSString *selectedPhoto;

// To Be POSTED Data
@property (nonatomic, strong)NSString *descText;
@end

@implementation RDPRecordCustomizeViewController

@synthesize voiceData, selectedBgMusic, selectedPhoto;
@synthesize albumView, descTextview;
@synthesize descText;

- (void)viewDidLoad {
    // Initialize mix player
    self.selectedBgMusic = @"bird";
    self.selectedPhoto = @"surface.png";
    [self.albumView setImage:[UIImage imageNamed:self.selectedPhoto]];
    _mixPlayer = [[RDPMixAudioPlayer alloc] init];
    [_mixPlayer playOcastraWithBgMusic:self.selectedBgMusic voice:self.voiceData];
    
    // Initialize mix machine
    _mixMachine = [[RDPMixAudioMachine alloc] init];
    _mixMachine.delegate = self;
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
        [self.albumView setImage:[UIImage imageNamed:self.selectedPhoto]];
        NSLog(@"%@", self.selectedPhoto);
    }
}

#pragma mark - RDPMixAudioMachineDelegate
- (void)mixAudioMachine:(RDPMixAudioMachine *)machine didMixSuccess:(NSData *)data {
    NSLog(@"mix complete");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"steven" password:@"hello"];
    NSDictionary *params = @{@"longitude":@"33.42", @"latitude":@"122.43", @"image_name":@"dog.jpg", @"description":@"Hello my dog!"};

    [manager POST:@"http://192.168.88.1:5000/voices/add"
       parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           [formData appendPartWithFileData:data name:@"voice_data" fileName:@"random-voide-name" mimeType:@"audio/mpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)mixAudioMachine:(RDPMixAudioMachine *)machine didMixFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

@end
