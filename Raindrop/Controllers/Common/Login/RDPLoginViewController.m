//
//  RDPLoginViewController.m
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPLoginViewController.h"
#import "RDPLoginManager.h"

@interface RDPLoginViewController ()<RDPLoginManagerDelegate>

@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *password;

@property (nonatomic, strong)RDPLoginManager *loginManager;
@end

@implementation RDPLoginViewController

@synthesize inputEmailLabel, inputPasswordLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    _email = inputEmailLabel.text;
    _password = inputPasswordLabel.text;
    
    // Check email and password empty
    if ([_email length] == 0 || [_password length] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"用户名或密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSDictionary *params = @{@"username":_email, @"password":_password};
        _loginManager = [RDPLoginManager sharedManager];
        _loginManager.delegate = self;
        [_loginManager loginWithParams:params];
    }
}

#pragma mark - RDPLoginManagerDelegate

- (void)loginManager:(RDPLoginManager *)manager didLoginSuccess:(NSData *)data {
    NSLog(@"Login successed\n%@", data);
}

- (void)loginManager:(RDPLoginManager *)manager didLoginFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

@end
