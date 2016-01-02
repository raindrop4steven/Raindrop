//
//  RDPLoginViewController.m
//  Raindrop
//
//  Created by user on 16/1/2.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "RDPLoginViewController.h"

@interface RDPLoginViewController ()

@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *password;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    _email = inputEmailLabel.text;
    _password = inputPasswordLabel.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"username":_email, @"password":_password};
    [manager POST:@"http://192.168.88.1:5000/api/users" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}
@end
