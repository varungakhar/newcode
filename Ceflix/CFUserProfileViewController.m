//
//  CFUserProfileViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 30/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFUserProfileViewController.h"
#import "CFConnectVideo.h"
#import "CFConnectTimelineItem.h"
#import "CFMeTopViewCell.h"
#import "CFConnectVideoCell.h"
#import "CFUser.h"
#import "CFCeflixService.h"

@interface CFUserProfileViewController ()

@property (nonatomic, strong) NSArray *userVideos;
@property (nonatomic, strong) CFUser *selectedUser;

@end

@implementation CFUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"USER-ID: %@", self.userID);
    [self fetchUserProfile];
    [self fetchUserVideos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.userVideos = nil;
    self.selectedUser = nil;
    self.userID = nil;
}

#pragma mark - Properties

- (NSArray *)userVideos {
    if (_userVideos == nil) {
        _userVideos = [[NSArray alloc] init];
    }
    
    return _userVideos;
}

- (CFUser *)selectedUser {
    if (_selectedUser == nil) {
        _selectedUser = [[CFUser alloc] init];
    }
    return _selectedUser;
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else {
        return [self.userVideos count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            CellIdentifier = @"Profile";
            CFMeTopViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [topCell configureCellForMeTopView:self.selectedUser];
            
            return topCell;
        }
        else {
            CellIdentifier = @"UserVideoCount";
            UITableViewCell *videoCountCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            NSString *videoCountLabelText = [NSString stringWithFormat:@"%@ VIDEOS", _selectedUser.userVideoCount];
            videoCountCell.textLabel.text = videoCountLabelText;
            [videoCountCell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
            
            return videoCountCell;
        }
    }
    else {
        CellIdentifier = @"connectItem";
        CFConnectVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        CFConnectTimelineItem *timelineItem = [self.userVideos objectAtIndex:indexPath.row];
        [cell configureCellForItem:timelineItem];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 30;
        }
        else {
            return 230;
        }
    }
    else {
        return 405;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // hook it up to video player
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 if (section == 0) {
 return nil;
 }
 else {
 
 }
 }
 */

#pragma mark - Actions

- (void)didPullRefresh:(id)sender {
    [self fetchUserProfile];
    [self fetchUserVideos];
}

#pragma mark - Private Helpers

- (void)fetchUserProfile {
    __weak typeof(self) weakSelf = self;
    CFCeflixService *service = [CFCeflixService sharedInstance];
    
    NSData *userIdData = [self.userID dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedUserID = [userIdData base64EncodedStringWithOptions:0];
    
    [service loadUserProfileWithUserID:base64EncodedUserID success:^(CFUser *user) {
        weakSelf.selectedUser = user;
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
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

- (void)fetchUserVideos {
    __weak typeof(self) weakSelf = self;
    
    NSData *userIdData = [self.userID dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedUserID = [userIdData base64EncodedStringWithOptions:0];
    
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service fetchVideosByUser:base64EncodedUserID success:^(NSArray *userVideos) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.userVideos = userVideos;
        [weakSelf.tableView reloadData];
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

@end
