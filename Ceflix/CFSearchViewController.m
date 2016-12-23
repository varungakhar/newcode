//
//  CFSearchViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 06/12/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFSearchViewController.h"
#import "CFCeflixService.h"
#import "CFVideoListCell.h"
#import "CFUserViewCell.h"
#import "CFChannelListCell.h"
#import "CFChannel.h"
#import "CFUser.h"
#import "CFCeflixRemoteVideo.h"
#import "NSArray+Enumerable.h"

@interface CFSearchViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) CFCeflixService *service;

@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, strong) NSArray *people;

- (IBAction)changeScope:(id)sender;

@end

@implementation CFSearchViewController

@synthesize searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.barTintColor = [UIColor grayColor];
    searchBar.placeholder = @"Search for videos, channels and people";
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    searchBar.barStyle = UISearchBarStyleMinimal;
    searchBar.translucent = NO;
    searchBar.tintColor = [UIColor colorWithRed:24/255.0 green:63/255.0 blue:156/255.0 alpha:0.9];
    [searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;

    // [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSArray *)channels {
    if (_channels == nil) {
        _channels = [[NSArray alloc] init];
    }
    return _channels;
}

- (NSArray *)videos {
    if (_videos == nil) {
        _videos = [[NSArray alloc] init];
    }
    return _videos;
}

- (NSArray *)people {
    if (_people == nil) {
        _people = [[NSArray alloc] init];
    }
    return _people;
}

- (CFCeflixService *)service {
    if (_service == nil) {
        _service = [CFCeflixService sharedInstance];
    }
    return _service;
    
}


#pragma mark - UISearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Term: %@", searchBar.text);
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        if ([self.videos count] == 0) {
            [self fetchVideoResults];
        }
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1) {
        if ([self.channels count] == 0) {
            [self fetchChannelResults];
        }
    }
    
    [searchBar resignFirstResponder];
}


#pragma mark - Actions

- (IBAction)changeScope:(id)sender {
    
    // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self fetchVideoResults];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1) {
        [self fetchChannelResults];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return [self.videos count];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        return [self.channels count];
    }
    else {
        return [self.people count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        CellIdentifier = @"videoCell";
        CFVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CFCeflixRemoteVideo *video = [self.videos objectAtIndex:indexPath.row];
        [cell configureCellForVideoList:video];
        
        return cell;
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        CellIdentifier = @"channelCell";
        CFChannelListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CFChannel *channel = [self.channels objectAtIndex:indexPath.row];
        [cell configureCell:channel];
        
        return cell;
    }
    else {
        CellIdentifier = @"userCell";
        CFUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CFUser *user = [self.people objectAtIndex:indexPath.row];
        [cell configureCellForUser:user];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return 100;
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        return 165;
    }
    else {
        return 60;
    }
}

#pragma mark - Private Helpers

- (void)fetchVideoResults {
    
    NSString *searchTerm = searchBar.text;
    __weak typeof(self) weakSelf = self;
    [[self service] fetchVideosFromSearchTerm:searchTerm success:^(NSDictionary *videoDict) {
        BOOL status = [[videoDict objectForKey:@"status"] boolValue];
        if (status) {
            NSArray *results = [videoDict objectForKey:@"data"][@"videos"];
            NSArray *videos = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFCeflixRemoteVideo alloc] initWithDictionary:obj];
            }];
            weakSelf.videos = videos;
            [weakSelf.tableView reloadData];
        }
        else {
            NSString *message = [videoDict objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
    
}


- (void)fetchChannelResults {
    
    NSString *searchTerm = searchBar.text;
    __weak typeof(self) weakSelf = self;
    [[self service] fetchChannelsFromSearchTerm:searchTerm success:^(NSDictionary *channelDict) {
        BOOL status = [[channelDict objectForKey:@"status"] boolValue];
        if (status) {
            NSArray *results = [channelDict objectForKey:@"data"][@"channels"];
            NSArray *channels = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFChannel alloc] initWithDictionary:obj];
            }];
            
            weakSelf.channels = channels;
            [weakSelf.tableView reloadData];
        }
        else {
            NSString *message = [channelDict objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
}

- (void)fetchPeopleResults {
    
    // NSString *searchTerm = searchBar.text;
    // [self service]
    
}

@end







