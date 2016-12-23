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
@property (nonatomic, strong) NSArray *livestreamvideo;
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
    
    if (indexPath.section==0) {
        CFCeflixRemoteVideo *liveVideo = self.liveVideos[indexPath.row];
        [cell configureCellForLiveVideo:liveVideo];
    }
    else
    {
CFCeflixRemoteVideo *liveVideo = self.livestreamvideo[indexPath.row];
[cell configureCellForLiveStream:liveVideo];
    }
    
    cell.delegate = self;
    cell.cellIndex = indexPath.row; // set indexPath if it's a grouped table
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    view.backgroundColor=[UIColor whiteColor];
    UILabel *lbl=[[UILabel alloc]init];
    lbl.frame=CGRectMake(5, 5, view.frame.size.width, 40);
    
    lbl.textColor=[UIColor redColor];
    if (section==0)
    {
          lbl.text=@"Features";
    }
    else
    {
          lbl.text=@"Currently Happening on Angles!";
    }

    [view addSubview:lbl];
    
    return view;
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.livestreamvideo count]>0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.liveVideos count];
    }
    if (section == 1) {
        return [self.livestreamvideo count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 363.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0)
    {

        NSDictionary *liveVideo = [[self.liveVideos objectAtIndex:indexPath.row] dictionaryRepresentation];
        NSLog(@"IndexPath = %ld", (long)indexPath.row);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:self userInfo:liveVideo];
    }
    else
    {
    NSDictionary *liveVideo = [[self.livestreamvideo objectAtIndex:indexPath.row] dictionaryRepresentationForLiveStream];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:self userInfo:liveVideo];
    }
   
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
        weakSelf.liveVideos = [liveVideos objectAtIndex:0];
        weakSelf.livestreamvideo=[liveVideos objectAtIndex:1];
        [weakSelf.tableView reloadData];
        // you might want to add NSLog here to log the array.
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Error Ni: %@", [error description]);
    }];
}

#pragma mark - CFLiveVideoViewCellDelegate

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withVideo:(CFCeflixRemoteVideo *)video {
    if (video) {
        CFChannelDetailsViewController *channelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"channelViewController"];
        video = (CFCeflixRemoteVideo *)[self.liveVideos objectAtIndex:cellIndex];
        channelViewController.channelID = video.channelID;
        [self.navigationController pushViewController:channelViewController animated:YES];
    }

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








