//
//  CFFollowersViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 11/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFFollowersViewController.h"
#import "CFCeflixService.h"
#import "CFUser.h"
#import "CFUserViewCell.h"

@interface CFFollowersViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *followers;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CFFollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"User ID: %@", self.userID);
    [self fetchFollowerForUser];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.followers = nil;
    self.userID = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.followers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"userCell";
    
    CFUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CFUser *user = [self.followers objectAtIndex:indexPath.row];
    [cell configureCellForUser:user];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // instantiate user profile view controller from story board and pass user id of selected user.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  60;
}

#pragma mark - Properties

- (NSArray *)followers {
    if (_followers == nil) {
        _followers = [[NSArray alloc] init];
    }
    
    return _followers;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

- (void)didPullRefresh:(id)sender {
    [self fetchFollowerForUser];
}

#pragma mark - Service Calls

- (void)fetchFollowerForUser {
    __weak typeof(self) weakSelf = self;
    
    NSData *userIDData = [self.userID dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [userIDData base64EncodedStringWithOptions:0];
    
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service fetchFollowersForUser:base64String success:^(NSArray *followers) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.followers = followers;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not load the user's followers" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

@end






