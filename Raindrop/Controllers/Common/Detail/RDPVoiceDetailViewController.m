//
//  RDPVoiceDetailViewController.m
//  Raindrop
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPVoiceDetailViewController.h"

@interface RDPVoiceDetailViewController ()

@end

@implementation RDPVoiceDetailViewController

@synthesize contentview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RDPVoiceDetailView *detail = [[[NSBundle mainBundle] loadNibNamed:@"RDPVoiceDetailView" owner:nil options:nil] objectAtIndex:0];
    
    [self.contentview addSubview:detail];
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

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
