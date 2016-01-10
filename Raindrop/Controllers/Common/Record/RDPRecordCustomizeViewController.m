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
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface RDPRecordCustomizeViewController ()<RDPMixAudioMachineDelegate, CLLocationManagerDelegate>

// Mix player for preview
@property (nonatomic, strong)RDPMixAudioPlayer *mixPlayer;

// Mix machine for output
@property (nonatomic, strong)RDPMixAudioMachine *mixMachine;

@property (nonatomic, strong)NSString *selectedBgMusic;
@property (nonatomic, strong)NSString *selectedPhoto;

// To Be POSTED Data
@property (nonatomic, strong)NSString *descText;
@property (nonatomic, strong)NSString *longitute;
@property (nonatomic, strong)NSString *latitude;

// Location Manger
@property (nonatomic, strong)CLLocationManager *locationManager;

// HUD
@property (nonatomic, strong)MBProgressHUD *HUD;

@end

@implementation RDPRecordCustomizeViewController

@synthesize voiceData, selectedBgMusic, selectedPhoto;
@synthesize albumView, descTextview;
@synthesize descText, longitute, latitude;
@synthesize locationManager;
@synthesize HUD;

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
    
    // Location Manger
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    

}


- (IBAction)upload:(id)sender {
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
    
//    [_mixMachine mixAudioWithBgMusic:self.selectedBgMusic voice:self.voiceData];
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
    if (self.descTextview.text.length == 0) {
        self.descText = @"All in my voice";
    } else {
        self.descText = self.descTextview.text;
    }
    NSDictionary *params = @{@"longitude":self.longitute, @"latitude":self.latitude, @"image_name":self.selectedPhoto, @"description":self.descText};

    [manager POST:@"http://192.168.88.1:5000/voices/add"
       parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           [formData appendPartWithFileData:data name:@"voice_data" fileName:[NSString stringWithFormat:@"mix-%d.m4a",arc4random() % 1000] mimeType:@"audio/mpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", uploadProgress.fractionCompleted);
        HUD.progress = uploadProgress.fractionCompleted;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HUD hide:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)mixAudioMachine:(RDPMixAudioMachine *)machine didMixFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - CLLocationManagerDelegatge
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitute = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(@"longitude : %@, latitude : %@", self.longitute, self.latitude);
    }
    
    // stop track location
    [manager stopUpdatingLocation];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Progress";
    [_mixMachine mixAudioWithBgMusic:self.selectedBgMusic voice:self.voiceData];
}

@end
