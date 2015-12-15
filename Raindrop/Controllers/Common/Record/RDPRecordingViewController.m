//
//  RDPRecordingViewController.m
//  Raindrop
//
//  Created by user on 15/12/14.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordingViewController.h"

@interface RDPRecordingViewController ()

@end

@implementation RDPRecordingViewController

@synthesize username;

- (void)viewDidLoad {
    self.userLabel.text = self.username;
}

- (IBAction)startRecord:(id)sender {
}

- (IBAction)resetRecord:(id)sender {
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
