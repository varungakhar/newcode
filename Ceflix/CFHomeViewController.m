//
//  CFHomeViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 23/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CFHomeViewController.h"
#import "CFCeflixRemoteVideo.h"
#import "CFHomeVideoCell.h"
#import "CFCeflixService.h"
#import "CFBannerTableViewCell.h"
#import "CFVideoPlayerViewController.h"
#import "CFTopNewVideosHeaderViewCell.h"
#import "CFTrendingVideosHeaderViewCell.h"
#import "CFChannelDetailsViewController.h"
#import "CFOptionsViewController.h"
#import "Ceflix-Swift-Fixed.h"


@interface CFHomeViewController () <CFOptionsMenuDelegate>

@property (nonatomic, strong) NSDictionary *homeScreenVideos;
@property (nonatomic, strong) NSArray *trendingVideos;
@property (nonatomic, strong) NSArray *recentVideos;
@property (nonatomic, strong) NSArray *banners;

@property (nonatomic,strong) CFOptionsMenu *optionsMenu;

@end

@implementation CFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self fetchHomeScreenContent];
    
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSDictionary *)homeScreenVideos {
    if (_homeScreenVideos == nil) {
        _homeScreenVideos = [[NSDictionary alloc] init];
    }
    return _homeScreenVideos;
}

- (NSArray *)trendingVideos {
    if (_trendingVideos == nil) {
        _trendingVideos = [[NSArray alloc] init];
    }
    
    return _trendingVideos;
}

- (NSArray *)recentVideos {
    if (_recentVideos == nil) {
        _recentVideos = [[NSArray alloc] init];
    }
    
    return _recentVideos;
}

- (NSArray *)banners {
    if (_banners == nil) {
        _banners = [[NSArray alloc] init];
    }
    
    return _banners;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [_recentVideos count];
    }
    else if (section == 2) {
        return [_trendingVideos count];
    }
    else {
        if ([self.banners count] > 0) {
            return 1;
        }
        else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    if (indexPath.section == 1) {
        CellIdentifier = @"VideoCell";
        CFHomeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.cellSection = indexPath.section;
        cell.cellIndex = indexPath.row;
        NSDictionary *recentVideoDict = [self.recentVideos objectAtIndex:indexPath.row]; // self.recentVideos[indexPath.row];
        // CFVideo *recentVideo = [[CFVideo alloc] initWithDictionary:recentVideoDict];
        [cell configureCellForHomeVideo:recentVideoDict];
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.section == 2) {
        CellIdentifier = @"VideoCell";
        CFHomeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.cellSection = indexPath.section;
        cell.cellIndex = indexPath.row;
        NSDictionary *trendingVideoDict = [self.trendingVideos objectAtIndex:indexPath.row]; // self.trendingVideos[indexPath.row];
        // CFVideo *trendingVideo = [[CFVideo alloc] initWithDictionary:trendingVideoDict];
        [cell configureCellForHomeVideo:trendingVideoDict];
        cell.delegate = self;
        
        return cell;
    }
    else {
        CellIdentifier = @"BannerTableViewCell";
        CFBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setCollectionData:self.banners];
        return cell;
    }
}


#pragma mark - NSNotification to select table cell

- (void)didSelectItemFromCollectionView:(NSNotification *)notification {
    NSDictionary *cellData = [notification object];
    if (cellData) {
        CFVideoPlayerViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"videoPlayer"];
        detailViewController.detailItem = cellData;
        [self presentViewController:detailViewController animated:YES completion:nil];
    }
}


#pragma mark - UITableView Delegates

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier;
    if (section == 0) {
        return nil;
    }
    else if (section == 1) {
        CellIdentifier = @"TopNewVideosHeader";
        CFTopNewVideosHeaderViewCell *topNewVideosHeaderCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return topNewVideosHeaderCell;
    }
    else {
        CellIdentifier = @"TrendingVideosHeader";
        CFTrendingVideosHeaderViewCell *trendingVideosHeaderCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return trendingVideosHeaderCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 165.0f;
    }
    else {
        return 363.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    else {
        if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
            return 0;
        } else {
            // whatever height you'd want for a real section header
            return 50.0;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    else if (indexPath.section == 1) {

        NSDictionary *recentVideo = [self.recentVideos objectAtIndex:indexPath.row];
        NSLog(@"IndexPath = %ld", (long)indexPath.row);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:self userInfo:recentVideo];
    }
    else {
        NSDictionary *trendingVideo = [self.trendingVideos objectAtIndex:indexPath.row];
        NSLog(@"IndexPath = %ld", (long)indexPath.row);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:self userInfo:trendingVideo];
    }
}

#pragma mark - Actions

- (void)didPullRefresh:(id)sender {
    [self fetchHomeScreenContent];
}


#pragma mark - Private Helpers 

- (void)fetchHomeScreenContent {
    __weak typeof(self) weakSelf = self;
    
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service fetchHomeScreenContentSuccess:^(NSDictionary *homeScreenContent) {
        [weakSelf.refreshControl endRefreshing];    
        weakSelf.recentVideos = homeScreenContent[@"data"][@"RecentVideos"];
        weakSelf.trendingVideos = homeScreenContent[@"data"][@"TrendingVideos"];
        weakSelf.banners = homeScreenContent[@"data"][@"banners"];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Error Ni: %@", [error description]);
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - CFLiveVideoViewDelegate 

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex inSection:(NSInteger)cellSection withVideo:(NSDictionary *)video {
    
    CFChannelDetailsViewController *channelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"channelViewController"];
    if (cellSection == 1) {
        video = [self.recentVideos objectAtIndex:cellIndex];
        channelViewController.channelID = video[@"channelID"];
        NSLog(@"%@", video[@"channelID"]);
    }
    else {
        video = [self.trendingVideos objectAtIndex:cellIndex];
        channelViewController.channelID = video[@"channelID"];
    }
    
    [self.navigationController pushViewController:channelViewController animated:YES];
     
}

- (void)didClickOnOptionsAtIndex:(NSInteger)cellIndex withData:(id)data byButton:(UIButton *)button {
    
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
