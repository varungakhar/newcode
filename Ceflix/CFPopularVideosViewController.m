//
//  CFPopularVideosViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 15/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFPopularVideosViewController.h"
#import "AppDelegate.h"
#import "CFCeflixService.h"
#import "CFCeflixRemoteVideo.h"
#import "CFAuthenticationViewController.h"

@interface CFPopularVideosViewController ()

@property (nonatomic, strong) NSArray *popularVideos;

@end

@implementation CFPopularVideosViewController

- (void)awakeFromNib {
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticationRequired:)
                                                 name:CFCeflixServiceAuthRequiredNotification
                                               object:nil];
     */
}

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self fetchPopularVideos];
}

#pragma mark - Notifications

- (void)authenticationRequired:(NSNotification *)notification {
    if (self.presentedViewController == nil) {
        [self performSegueWithIdentifier:@"AuthenticationSegue" sender:nil];
    }
}

#pragma mark - CFAuthenticationViewControllerDelegate

- (void)authenticationViewControllerSucceeded:(CFAuthenticationViewController *)authVC {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self fetchPopularVideos];
}

#pragma mark - Properties

- (NSArray *)popularVideos {
    if (_popularVideos == nil) {
        _popularVideos = [[NSArray alloc] init];
    }
    
    return _popularVideos;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.popularVideos count];
    }
    
    return 0;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PopularVideoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CFCeflixRemoteVideo *poplularVideo = self.popularVideos[indexPath.row];
    cell.textLabel.text = poplularVideo.title;
    cell.detailTextLabel.text = poplularVideo.videoDescription;
    return cell;
    
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // bla bla bla.
}

#pragma mark - Actions

- (void)didPullRefresh:(id)sender {
    [self fetchPopularVideos];
}

#pragma mark - Private Helpers

- (void)fetchPopularVideos {
    
    __weak typeof(self) weakSelf = self;
    
    CFCeflixService *service = [CFCeflixService sharedInstance];
    
    // if (service.serverRoot) {
        [service fetchPopularVideosSuccess:^(NSArray *popularVideos) {
            [weakSelf.refreshControl endRefreshing];
            weakSelf.popularVideos = popularVideos;
            [weakSelf.tableView reloadData];
            
            NSLog(@"The data - %@", popularVideos);
            
        } failure:^(NSError *error) {
            [weakSelf.refreshControl endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"Error Ni: %@", [error description]);
        }];
    // }
//    else {
//        [self performSegueWithIdentifier:@"AuthenticationSegue" sender:nil];
//    }
    
}


@end



/*
 - (void)fetchPopvideo {
 
 NSURL *url = [NSURL URLWithString:@"http://api.ceflix.org/api/popularVideos"];
 NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
 NSOperationQueue *queue = [[NSOperationQueue alloc] init];
 
 [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
 {
 
 NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
 NSLog(@"%@",dictionary);
 }];
 
 }
 */








