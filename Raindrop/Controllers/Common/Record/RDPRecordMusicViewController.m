//
//  RDPRecordMusicViewController.m
//  Raindrop
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 steven. All rights reserved.
//

#import "RDPRecordMusicViewController.h"
#import "RDPMusicTableViewCell.h"
#import "RDPBgMusic.h"
#import "RDPMixAudioPlayer.h"

static NSString *kRDPCellIdentifier = @"RDPMusicTableViewCell";

@interface RDPRecordMusicViewController ()<RDPMusicTableCellDelegate>

@property (nonatomic, strong)NSMutableArray *songSource;

// Mix player for preview
@property (nonatomic, strong)RDPMixAudioPlayer *mixPlayer;

@end

@implementation RDPRecordMusicViewController

@synthesize voiceData, selectedBgMusic;
@synthesize songTableView;

- (void)viewDidLoad {
    // Initliaze data source
    _songSource = [[NSMutableArray alloc] init];
    [self generateSource];
    
    // Initliaze mix audio player
    _mixPlayer = [[RDPMixAudioPlayer alloc] init];
    
    // SongTableView delegate
    self.songTableView.delegate = self;
    self.songTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"RDPMusicTableViewCell" bundle:nil];
    [[self songTableView] registerNib:nib forCellReuseIdentifier:kRDPCellIdentifier];
    
}

#pragma mark - UITableViewDataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // configure our cell content
    RDPBgMusic *music = [_songSource objectAtIndex:[indexPath row]];
    
    RDPMusicTableViewCell *cell = (RDPMusicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kRDPCellIdentifier];
    if (cell == nil) {
        cell = [[RDPMusicTableViewCell alloc] init];
    }
    [cell.songImageView setImage:[UIImage imageNamed:music.imageName]];
    cell.songName = music.songName;
    cell.songId = [indexPath row];
    [cell.songNameLabel setText:music.songName];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Click cell at row : %ld", [indexPath row]);
    
}

#pragma mark - RDPMusicTableCellDelegate
// Click to preview mix audio
- (void)RDPMusicCell:(RDPMusicTableViewCell *)cell playButtonPressed:(UIButton *)button {
    // Change icon
    [button setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    // Get song name
    NSString *bgMusic = cell.songName;
    [_mixPlayer playOcastraWithBgMusic:bgMusic voice:self.voiceData];
    self.selectedBgMusic = bgMusic;
}

- (void)RDPMusicCell:(RDPMusicTableViewCell *)cell CheckButtonPressed:(UIButton *)button {
    
}



// Generate bg source by man hande
- (void)generateSource {
    // bird
    RDPBgMusic *bird = [[RDPBgMusic alloc] init];
    bird.songName = @"bird";
    bird.songCategory = @"抒情";
    bird.imageName = @"cell1.png";
    [_songSource addObject:bird];
    
    // elegant
    RDPBgMusic *elegant = [[RDPBgMusic alloc] init];
    elegant.songName = @"fire";
    elegant.songCategory = @"古典";
    elegant.imageName = @"cell2.png";
    [_songSource addObject:elegant];
}
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
