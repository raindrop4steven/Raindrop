//
//  RDPRegisterViewController.m
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPRegisterViewController.h"
#import "RDPRegisterManager.h"
#import "RDPTokenManager.h"

@interface RDPRegisterViewController ()<RDPRegisterManagerDelegate, RDPTokenManagerDelegate>
@property (nonatomic, strong)RDPRegisterManager *manager;
@property (nonatomic, strong)RDPTokenManager *tokenManager;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *password;
@end

@implementation RDPRegisterViewController

@synthesize emailLabel, passwordLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(id)sender {
    _email = self.emailLabel.text;
    _password = self.passwordLabel.text;
    
    // Check email and password empty
    if ([_email length] == 0 || [_password length] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"用户名或密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSDictionary *params = @{@"username":_email, @"password":_password};
        _manager = [RDPRegisterManager sharedManager];
        _manager.delegate = self;
        [_manager registerWithParams:params];
    }
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RDPRegisterManagerDelegate
- (void)registerManager:(RDPRegisterManager *)manager didRegisterSuccess:(NSData *)data {
    NSLog(@"%@", data);
    _tokenManager = [RDPTokenManager sharedManager];
    _tokenManager.delegate = self;
    NSDictionary *params = @{@"username":_email, @"password":_password};
    [_tokenManager getTokenWithParams:params];
}

- (void)registerManager:(RDPRegisterManager *)manager didRegisterFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - RDPTokenManagerDelegate
- (void)tokenManager:(RDPTokenManager *)manager didGetTokenSuccess:(NSDictionary *)dict {
    NSLog(@"%@", dict);
    NSString *token = [dict objectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    NSLog(@"Token saved");
}

- (void)tokenManager:(RDPTokenManager *)manager didGetTokenFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}
@end
