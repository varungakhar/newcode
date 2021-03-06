//
//  CFLiveViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 25/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFLiveViewController.h"
#import "AppDelegate.h"
#import "CFCeflixService.h"
#import "CFCeflixRemoteVideo.h"
#import "CFLiveVideoViewCell.h"
#import "CFChannelDetailsViewController.h"
#import "Ceflix-Swift-Fixed.h"

@interface CFLiveViewController () <CFOptionsMenuDelegate>
@property (nonatomic, strong) NSArray *liveVideos;
@property (nonatomic,strong) CFOptionsMenu *optionsMenu;
@end

@implementation CFLiveViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self fetchLiveVideos];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Properties

- (NSArray *)liveVideos {
    if (_liveVideos == nil) {
        _liveVideos = [[NSArray alloc] init];
    }
    
    return _liveVideos;
}


#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoCell";
    CFLiveVideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CFCeflixRemoteVideo *liveVideo = self.liveVideos[indexPath.row];
    [cell configureCellForLiveVideo:liveVideo];
    
    cell.delegate = self;
    cell.cellIndex = indexPath.row; // set indexPath if it's a grouped table
    
    return cell;
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.liveVideos count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 363.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *liveVideo = [[self.liveVideos objectAtIndex:indexPath.row] dictionaryRepresentation];
    NSLog(@"IndexPath = %ld", (long)indexPath.row);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:self userInfo:liveVideo];
}

#pragma mark - Actions

- (void)didPullRefresh:(id)sender {
    [self fetchLiveVideos];
}

#pragma mark - Private Helpers

- (void)fetchLiveVideos {
    __weak typeof(self) weakSelf = self;
    
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service fetchLiveVideosSuccess:^(NSArray *liveVideos) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.liveVideos = liveVideos;
        [weakSelf.tableView reloadData];
        // you might want to add NSLog here to log the array.
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okayAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - CFLiveVideoViewCellDelegate

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withVideo:(CFCeflixRemoteVideo *)video {
    CFChannelDetailsViewController *channelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"channelViewController"];
    video = (CFCeflixRemoteVideo *)[self.liveVideos objectAtIndex:cellIndex];
    channelViewController.channelID = video.channelID;
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








