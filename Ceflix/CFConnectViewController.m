//
//  CFConnectViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 06/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFConnectViewController.h"
#import "CFConnectVideoCell.h"
#import "CFConnectVideo.h"
#import "CFConnectTimelineItem.h"
#import "CFAPIClient.h"
#import "CFCeflixService.h"
#import "CFConnectVideoUpload.h"
#import "CFUploadVideoViewController.h"
#import "CFConnectVideoProgressCell.h"
#import "CFUserProfileViewController.h"

/**
 * The user-defaults key for the user identifier
 */
static NSString *const CFUserIdentifierKey = @"UserIdentifier";

@interface CFConnectViewController () <CFUploadVideoViewControllerDelegate, CFConnectVideoCellDelegate>

@property (nonatomic, strong) NSArray *connectTimelineItems;
@property (nonatomic, assign) NSUInteger requestIdentifier;

@property (nonatomic, strong) NSMutableArray *uploads; // this means you can upload more than on video at a time.

@end

@implementation CFConnectViewController

@synthesize requestIdentifier;


#pragma mark - View Controller Life Cycle

- (void)dealloc {
    // remove some notifications observers
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    self.uploads = [NSMutableArray arrayWithArray:[CFConnectVideoUpload allUploads]];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(uploadProgressed:) name:CFAPIClientUploadProgressNotification object:nil];
    [nc addObserver:self selector:@selector(backgroundUploadCompleted:) name:CFAPIClientBackgroundUploadCompletedNotification object:nil];
    [nc addObserver:self selector:@selector(backgroundUploadFailed:) name:CFAPIClientBackgroundUploadFailedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.tableView.rowHeight = // set table row height to be automatic resizing
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(didPullRefresh:) forControlEvents:UIControlEventValueChanged];
    
    requestIdentifier = NSNotFound;
    [self fetchConnectTimelineItems];
    
    // for uploads section
    // self.tableView.rowHeight = CFConnectVideoProgressCellHeight;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)connectVideos {
    if (_connectTimelineItems == nil) {
        _connectTimelineItems = [[NSArray alloc] init];
    }
    return _connectTimelineItems;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return [self.uploads count];
    }
    else {
        return self.connectTimelineItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CFConnectVideoProgressCell *cell = (CFConnectVideoProgressCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
        cell.upload = self.uploads[indexPath.row];
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"connectItem";
        CFConnectVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        CFConnectTimelineItem *timelineItem = [self.connectTimelineItems objectAtIndex:indexPath.row];
        cell.cellIndex = indexPath.row;
        [cell configureCellForItem:timelineItem];
        cell.delegate = self;
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CFConnectVideoUpload *upload = self.uploads[indexPath.row];
        if (upload.preparationRequestIdentifier != NSNotFound) {
            [[CFAPIClient sharedInstance] cancelRequestWithIdentifier:upload.preparationRequestIdentifier];
        }
        else if (upload.uploadRequestIdentifier != NSNotFound) {
            [[CFAPIClient sharedInstance] cancelRequestWithIdentifier:upload.uploadRequestIdentifier];
        }
        
        [tableView beginUpdates];
        {
            [self.uploads removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [tableView endUpdates];
        
        [upload delete];
    }
}


#pragma mark - TableView Delegates 

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
    if (section == 1) {
        if ([[CFCeflixService sharedInstance] isUserSignedIn]) {
            return CGFLOAT_MIN;
        }
        else {
            return 470.0;
        }
    }
    else {
        return CGFLOAT_MIN;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CFConnectTimelineItem *connectItem = [self.connectTimelineItems objectAtIndex:indexPath.row];
        NSDictionary *selectedVideo = [connectItem.videoData dictionaryRepresentation];
        NSLog(@"IndexPath = %ld", (long)indexPath.row);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:self userInfo:selectedVideo];
    }
}

#pragma mark - Notifications

- (void)backgroundUploadCompleted:(NSNotification *)notification {
    NSUInteger requestID = [notification.object unsignedIntegerValue];
    NSLog(@"%s requestID=%lu", __PRETTY_FUNCTION__, (unsigned long)requestID);
    
    for (CFConnectVideoUpload *upload in self.uploads) {
        if (requestID == upload.uploadRequestIdentifier) {
            [upload delete];
            [self removeUpload:upload];
            break;
        }
    }
}

- (void)backgroundUploadFailed:(NSNotification *)notification {
    NSUInteger requestID = [notification.object unsignedIntegerValue];
    NSLog(@"%s requestID=%lu", __PRETTY_FUNCTION__, (unsigned long)requestID);
    
    NSError *error = notification.userInfo[CFAPIClientBackgroundRequestFailedErrorKey];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [alert addAction:okay];
    [self presentViewController:alert animated:YES completion:NULL];
    
}

- (void)uploadProgressed:(NSNotification *)notification {
    NSUInteger taskIndentifier = [notification.object unsignedIntegerValue];
    
    for (CFConnectVideoUpload *upload in self.uploads) {
        if (upload.preparationRequestIdentifier == taskIndentifier || upload.uploadRequestIdentifier) {
            NSNumber *bytesSoFar = notification.userInfo[CFAPIClientUploadBytesUploaded];
            
            if (taskIndentifier == upload.preparationRequestIdentifier) {
                [upload updateThumbnailImageProgress:bytesSoFar];
            }
            else {
                [upload updateVideoContentProgress:bytesSoFar];
            }
            
            break;
        }
    }
}

#pragma mark - Private Helpers

- (void)removeUpload:(CFConnectVideoUpload *)upload {
    [self.tableView beginUpdates];
    {
        NSUInteger index = [self.uploads indexOfObject:upload];
        if (index != NSNotFound) {
            [self.uploads removeObjectAtIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self.tableView endUpdates];
}


#pragma mark - Networking

/*
- (void)uploadVideo:(CFConnectVideoUpload *)upload toPath:(NSString *)path {
    
    CFAPIClient *client = [CFAPIClient sharedInstance];
    NSUInteger requestID = [client uploadVideoFromURL:upload.localMovieURL toPath:path];
    
    upload.uploadRequestIdentifier = requestID;
    [upload save];
}

- (void)submitUpload:(CFConnectVideoUpload *)upload {
    
    __weak typeof(self) weakSelf = self;
    
    CFAPIClient *client = [CFAPIClient sharedInstance];
    NSUInteger requrestID = [client prepareVideoWithCaption:upload.video.caption thumbnail:upload.thumbnailImage duration:upload.video.duration tags:upload.video.tags success:^(NSString *path) {
        [upload updateThumbnailImageProgress:upload.thumbnailImageSize];
        upload.preparationRequestIdentifier = NSNotFound;
        [upload save];
        [weakSelf uploadVideo:upload toPath:path];
    } failure:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Preparation Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:NULL];
    }];
    upload.preparationRequestIdentifier = requrestID;
    [upload save];
    
}
*/
 
- (void)fetchConnectTimelineItems {
    if (!self.refreshControl.isRefreshing) {
        [self.refreshControl beginRefreshing];
    }
    
    if (requestIdentifier != NSNotFound) {
        [[CFAPIClient sharedInstance] cancelRequestWithIdentifier:self.requestIdentifier];
        requestIdentifier = NSNotFound;
    }
    
    __weak typeof(self) weakSelf = self;
    // requestIdentifier =
    [[CFAPIClient sharedInstance] fetchTimeLineItemsWithSuccess:^(NSArray *connectTimelineItems) {
        weakSelf.connectTimelineItems = connectTimelineItems;
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
        weakSelf.requestIdentifier = NSNotFound;
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.requestIdentifier = NSNotFound;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okayAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - Public Methods

- (void)updateItems:(NSArray *)connectTimelineItems {
    self.connectTimelineItems = connectTimelineItems;
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navVC = (UINavigationController *)segue.destinationViewController;
    CFUploadVideoViewController *videoVC = (CFUploadVideoViewController *)navVC.topViewController;
    videoVC.delegate = self;
}

/*
#pragma mark - CFUploadVideoViewControllerDelegate

- (void)uploadVideoController:(CFUploadVideoViewController *)controller requestsUploadFor:(CFConnectVideoUpload *)upload {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView beginUpdates];
        {
            [self.uploads insertObject:upload atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [self submitUpload:upload];
        }
        [self.tableView endUpdates];
    }];
}
 */

#pragma mark - Actions

- (void)didPullRefresh:(id)sender {
    [self fetchConnectTimelineItems];
}

/*
 
 weakSelf.connectTimelineItems = connectTimelineItems;
 [weakSelf.tableView reloadData];
 [weakSelf.refreshControl endRefreshing];
 weakSelf.requestIdentifier = NSNotFound;
 
 [weakSelf.refreshControl endRefreshing];
 weakSelf.requestIdentifier = NSNotFound;
 
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
 UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 [weakSelf dismissViewControllerAnimated:YES completion:nil];
 }];
 [alert addAction:okayAction];
 [weakSelf presentViewController:alert animated:YES completion:nil];
 */

#pragma mark - CFConnectVideoCellDelegate

- (void)didClickOnOptionsAtIndex:(NSInteger)cellIndex withVideo:(CFConnectVideo *)video byButton:(UIButton *)button {
    
    NSLog(@"Options Button Pressed");
    
}

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withVideo:(CFConnectVideo *)video {
    CFUserProfileViewController *userProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"userProfileViewController"];
    CFConnectTimelineItem *connectItem = [self.connectTimelineItems objectAtIndex:cellIndex];
    video = connectItem.videoData;
    userProfileViewController.userID = connectItem.userID;
    NSLog(@"USER-ID: %@", connectItem.userID);
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

@end









