//
//  RDPRecordMotionViewController.m
//  Raindrop
//
//  Created by user on 15/12/14.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordMotionViewController.h"
#import "RDPRecordingViewController.h"

@interface RDPRecordMotionViewController ()

@property (nonatomic, strong) NSString *myMotion;

@end

@implementation RDPRecordMotionViewController

@synthesize clockView, dateLabel;
@synthesize selectedMotion;
@synthesize laughBtn, happyBtn, surpriseBtn, sadBtn, angryBtn;


- (void)viewDidLoad {
    
    // 1. Setup date
    [self setupDate];
    
    // 2. Setup default value
    self.myMotion = @"心情";
    [self setMotionLabelWith:self.myMotion];
    
    // 3. Setup default motion image
    //[self setupMotions];
}

- (void)setupDate {
    // 1. Set current date
    NSString *currentDate = [NSDate stringYearMonthDayWithDate:nil];
    [dateLabel setText:currentDate];
    
    // 2. Set clock view
    [clockView setContentMode:UIViewContentModeScaleAspectFill];
    [clockView setImage:[UIImage imageNamed:@"clock.png"]];
}

- (void)setMotionLabelWith:(NSString *)motion {
    [selectedMotion setText:motion];
}

// go back to parent
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)laugh:(id)sender {
    self.myMotion = @"大笑";
    [self setMotionLabelWith:self.myMotion];
}

- (IBAction)happy:(id)sender {
    self.myMotion = @"开心";
    [self setMotionLabelWith:self.myMotion];
}

- (IBAction)surprise:(id)sender {
    self.myMotion = @"惊讶";
    [self setMotionLabelWith:self.myMotion];
}

- (IBAction)angry:(id)sender {
    self.myMotion = @"生气";
    [self setMotionLabelWith:self.myMotion];
}

- (IBAction)sad:(id)sender {
    self.myMotion = @"伤心";
    [self setMotionLabelWith:self.myMotion];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RDPStartRecordSegue"]) {
        RDPRecordingViewController *recordingController = (RDPRecordingViewController *)segue.destinationViewController;
        recordingController.username = self.myMotion;
    }
}
@end
