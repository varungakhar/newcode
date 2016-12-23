//
//  CFMeViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 22/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFMeViewController.h"
#import "CFMeTopViewCell.h"
#import "CFSettingsViewController.h"
#import "CFCeflixService.h"
#import "CFFollowersViewController.h"
#import "CFFollowingViewController.h"

/**
 * The user-defaults key for the user identifier
 */
static NSString *const CFUserIdentifierKey = @"UserIdentifier";

/**
 * The user-defaults key for the current user
 */
static NSString *const CFCurrentUserKey = @"CurrentUser";

@interface CFMeViewController ()
@property (nonatomic, strong) CFUser *currentUser;
@property (nonatomic, strong) NSString *userID;
@end

@implementation CFMeViewController {
    
    NSArray *profileItems;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    profileItems = @[@"MyVideos", @"MySubscriptions", @"SavedVideos", @"Activities"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[CFCeflixService sharedInstance] isUserSignedIn]) {
        [self fetchUserProfile];
        NSLog(@"%@", self.currentUser.userPublicID);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegates and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if ([[CFCeflixService sharedInstance] isUserSignedIn]) {
            return 1;
        }
        else {
            return 0;
        }
    }
    else {
        if ([[CFCeflixService sharedInstance] isUserSignedIn]) {
            return [profileItems count];
        }
        else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier;
    if (indexPath.section == 0) {
        CellIdentifier = @"Profile";
        CFMeTopViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        [topCell configureCellForMeTopView:self.currentUser];
        self.userID = self.currentUser.userPublicID;
        return topCell;
    }
    else {
        CellIdentifier = [profileItems objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 250;
    }
    else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        if ([[CFCeflixService sharedInstance] isUserSignedIn]) {
            return nil;
        }
        else {
            UITableViewCell *meFooterCell = [tableView dequeueReusableCellWithIdentifier:@"MeFooter"];
            return meFooterCell;
        }
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else {
        if ([[CFCeflixService sharedInstance] isUserSignedIn]) {
            return CGFLOAT_MIN;
        }
        else {
            return 470.0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return CGFLOAT_MIN;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        UINavigationController *navigationViewController = (UINavigationController *)segue.destinationViewController;
        CFLoginViewController *loginViewController = [navigationViewController.viewControllers objectAtIndex:0];
        loginViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"showFollowers"]) {
        CFFollowersViewController *followersViewController = (CFFollowersViewController *)segue.destinationViewController;
        followersViewController.userID = self.userID;
    }
    else if ([segue.identifier isEqualToString:@"showFollowing"]) {
        CFFollowingViewController *followingViewController = (CFFollowingViewController *)segue.destinationViewController;
        followingViewController.userID = self.userID;
    }
}


#pragma mark - Actions



#pragma mark - CFLoginViewControllerDelegate

- (void)loginViewControllerSucceeded:(CFLoginViewController *)loginViewController {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self fetchUserProfile];
}

#pragma mark - Service Calls

- (void)fetchUserProfile {
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service loadUserProfileSuccess:^(CFUser *user) {
        self.currentUser = user;
        [self.tableView reloadData];
        NSLog(@"%@", self.currentUser.userPublicID);
    } failure:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

@end











