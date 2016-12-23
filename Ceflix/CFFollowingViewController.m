//
//  CFFollowingViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 11/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFFollowingViewController.h"
#import "CFCeflixService.h"
#import "CFUser.h"
#import "CFUserViewCell.h"

@interface CFFollowingViewController ()

@property (nonatomic, strong) NSArray *followees;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) CFCeflixService *service;

@end

@implementation CFFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"User ID: %@", self.userID);
    [self fetchFolloweesForUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.followees = nil;
    self.userID = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSArray *)followees {
    if (_followees == nil) {
        _followees = [[NSArray alloc] init];
    }
    
    return _followees;
}

- (CFCeflixService *)service {
    if (_service == nil) {
        _service = [CFCeflixService sharedInstance];
    }
    
    return _service;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.followees count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"userCell";
    
    CFUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CFUser *user = [self.followees objectAtIndex:indexPath.row];
    [cell configureCellForUser:user];
    
    return cell;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // instantiate user profile view controller from story board and pass user id of selected user.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - Actions 

- (void)didPullRefresh:(id)sender {
    [self fetchFolloweesForUser];
}

#pragma mark - Service Calls

- (void)fetchFolloweesForUser {
    __weak typeof(self) weakSelf = self;
    
    NSData *userIDData = [self.userID dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [userIDData base64EncodedStringWithOptions:0];
    
    [self.service fetchFollowingUsersForUser:base64String success:^(NSArray *followingUsers) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.followees = followingUsers;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to load users" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

@end
