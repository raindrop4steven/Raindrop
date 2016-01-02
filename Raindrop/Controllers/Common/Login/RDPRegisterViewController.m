//
//  RDPRegisterViewController.m
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPRegisterViewController.h"

@interface RDPRegisterViewController ()

@end

@implementation RDPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)register:(id)sender {
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
