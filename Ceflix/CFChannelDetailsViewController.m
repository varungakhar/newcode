//
//  CFChannelDetailsViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 30/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFChannelDetailsViewController.h"
#import "CFCeflixService.h"
#import "CFVideo.h"
#import "CFChannel.h"
#import "CFChannelTopViewCell.h"
#import "CFVideoListCell.h"
#import "NSArray+Enumerable.h"
#import "Ceflix-Swift-Fixed.h"

@interface CFChannelDetailsViewController () <CFOptionsMenuDelegate>

@property (nonatomic, strong) NSArray *channelVideos;
@property (nonatomic, strong) NSDictionary *channelDetails;
@property (nonatomic,strong) CFOptionsMenu *optionsMenu;

@end

@implementation CFChannelDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"CHANNEL-ID: %@", self.channelID);
    [self fetchChannelDetails];
    NSLog(@"ChannelVideos:%@", self.channelVideos);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.channelVideos = nil;
    self.channelDetails = nil;
    self.channelID = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.channelVideos count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier;
    
    if (indexPath.row == 0) {
        CellIdentifier = @"ChannelProfile";
        CFChannelTopViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        [topCell configureCellForChannelTopView:self.channelDetails];
        
        return topCell;
    }
    else if (indexPath.row == 1) {
        CellIdentifier = @"ChannelVideoCount";
        UITableViewCell *videoCountCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *videoCountLabelText = [NSString stringWithFormat:@"%@ VIDEOS", [_channelDetails objectForKey:@"VideoCount"]];
        videoCountCell.textLabel.text = videoCountLabelText;
        [videoCountCell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
        
        return videoCountCell;
    }
    else {
        CellIdentifier = @"ChannelVideo";
        CFVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSInteger row = indexPath.row - 2;
        CFCeflixRemoteVideo *video = (CFCeflixRemoteVideo *)[self.channelVideos objectAtIndex:row];
        [cell configureCellForVideoList:video];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 30;
    }
    else if (indexPath.row == 0) {
        return 255;
    }
    else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1) {
        NSInteger row = indexPath.row - 2;
        CFVideo *channelVideo = [self.channelVideos objectAtIndex:row];
        NSDictionary *channelVideoDict = [NSDictionary dictionaryWithObject:channelVideo forKey:@"video"];
        NSLog(@"Row = %ld", (long)row);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:self userInfo:channelVideoDict];
    }
}

#pragma mark - Properties

- (NSArray *)channelVideos {
    if (_channelVideos == nil) {
        _channelVideos = [[NSArray alloc] init];
    }
    
    return _channelVideos;
}

- (NSDictionary *)channelDetails {
    if (_channelDetails == nil) {
        _channelDetails = [[NSDictionary alloc] init];
    }
    return _channelDetails;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Actions

- (void)didPullRefresh:(id)sender {
    [self fetchChannelDetails];
}

#pragma mark - Private Helpers 

- (void)fetchChannelDetails {
    
    __weak typeof(self) weakSelf = self;
    
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service fetchChannelWithID:self.channelID success:^(NSDictionary *channel) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.channelDetails = channel[@"data"][@"0"];
        weakSelf.channelVideos = [channel[@"data"][@"channelVideos"] mappedArrayWithBlock:^id(id obj) {
            return [[CFCeflixRemoteVideo alloc] initWithDictionary:obj];
        }];
        
        NSLog(@"Channel Details: %@, Channel Videos: %@", self.channelDetails, self.channelVideos);
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Channel Profile can't be loaded at this time due to an Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Error: %@ - %@", [error description], error.localizedDescription);
    }];
    
}

#pragma mark - CFVideoListCellDelegate 

- (void)didClickOptionsAtIndex:(NSInteger)cellIndex withData:(id)data byButton:(UIButton *)button {
    self.optionsMenu = [[CFOptionsMenu alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.optionsMenu.delegate = self;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.optionsMenu];
    [self.optionsMenu animate];
}


#pragma mark - CFOptionsMenuView Delegate

- (void)hideOptionsMenuViewWithStatus:(BOOL)status {
    if (status == true) {
        [self.optionsMenu removeFromSuperview];
    }
}

@end













