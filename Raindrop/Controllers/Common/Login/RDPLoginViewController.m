//
//  RDPLoginViewController.m
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPLoginViewController.h"
#import "RDPTokenManager.h"
#import "MainViewController.h"

@interface RDPLoginViewController ()<RDPTokenManagerDelegate>

@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *password;

@property (nonatomic, strong)RDPTokenManager *tokenManager;
@end

@implementation RDPLoginViewController

@synthesize inputEmailLabel, inputPasswordLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    _tokenManager = [RDPTokenManager sharedManager];
    _tokenManager.delegate = self;
    
    // Check token in userdefaults first if not show up login window
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if (token != nil) {
        // Login with token then jump to home view
        NSDictionary *params = @{@"username":token, @"password":@"notpassword"};
        [_tokenManager getTokenWithParams:params];
    } else {
        // show login window
        // actually do nothing here.
    }
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
        [_tokenManager getTokenWithParams:params];
    }
}

#pragma mark - RDPTokenManagerDelegate
- (void)tokenManager:(RDPTokenManager *)manager didGetTokenSuccess:(NSDictionary *)dict {
    NSLog(@"%@", dict);
    NSString *token = [dict objectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    NSLog(@"Token saved");
    
    // Load Main View
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tokenManager:(RDPTokenManager *)manager didGetTokenFailed:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

@end
