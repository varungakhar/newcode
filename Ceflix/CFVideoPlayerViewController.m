//
//  CFVideoPlayerViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 02/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFVideoPlayerViewController.h"
#import "CFVideoTitleDetailViewCell.h"
#import "CFVideoChannelDetailViewCell.h"
#import "CFVideoDescriptionDetailViewCell.h"
#import "CFSegmentedHeaderViewCell.h"
#import "CFVideoListCell.h"
#import "CFVideoScreenFooterCell.h"

@interface CFVideoPlayerViewController ()
@property (strong, nonatomic) NSArray *relatedVideos;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSArray *likers;
@property (assign, nonatomic) BOOL isRowHidden;
@end

@implementation CFVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    // [self.bottomView setHidden:YES];
    if (self.detailItem) {
        // self.detailsLabel.text = self.detailItem[@"contentName"];
    }
}

- (void)setDetailItem:(NSDictionary *)newdetailItem {
    if (_detailItem != newdetailItem) {
        _detailItem = newdetailItem;
        [self configureView];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSArray *)relatedVideos {
    if (!_relatedVideos) {
        _relatedVideos = [[NSArray alloc] init];
    }
    
    return _relatedVideos;
}

- (NSArray *)comments {
    if (!_comments) {
        _comments = [[NSArray alloc] init];
    }
    
    return _comments;
}

- (NSArray *)likers {
    if (!_likers) {
        _likers = [[NSArray alloc] init];
    }
    
    return _likers;
}



/*
- (IBAction)optionsPressed:(id)sender {
    
    UIAlertController *optionsActionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addToWatchLater = [UIAlertAction actionWithTitle:@"Add to Watch Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // call the method that does HTTP POST to add to watch later API
        [optionsActionSheet dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // call the method that shows UIActivity for sharing to other platforms
        [optionsActionSheet dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [optionsActionSheet dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [optionsActionSheet addAction:addToWatchLater];
    [optionsActionSheet addAction:share];
    [optionsActionSheet addAction:cancel];
    [self presentViewController:optionsActionSheet animated:YES completion:nil];
    
}
*/
 
- (IBAction)xButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else {
        return [self.relatedVideos count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CellIdentifier = @"VideoTitleDetail";
            CFVideoTitleDetailViewCell *titleDetailCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            // [titleDetailCell configureCell];
            return titleDetailCell;
        }
        else if (indexPath.row == 1) {
            CellIdentifier = @"descriptionDetail";
            CFVideoDescriptionDetailViewCell *descriptionDetailCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // [descriptionDetailCell configureCell];
            return descriptionDetailCell;
        }
        else {
            CellIdentifier = @"channelDetail";
            CFVideoChannelDetailViewCell *videoChannelDetail = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // [videoChannelDetail configureCell];
            return videoChannelDetail;
        }
    }
    else {
        CellIdentifier = @"RelatedVideo";
        CFVideoListCell *relatedVideosCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        // [relatedVideosCell configureCellForVideoList:<#(CFVideo *)#>]
        return relatedVideosCell;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.isRowHidden) {
                self.isRowHidden = NO;
                [tableView reloadData];
            }
            else {
                self.isRowHidden = YES;
                 [tableView reloadData];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (self.isRowHidden) {
                return 60;
            }
            else {
                return 0.0;
            }
        }
        return 60.0;
    }
    else {
        return 100.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier;
    if (section == 0) {
        return nil;
    }
    else {
        CellIdentifier = @"SegmentedHeader";
        CFSegmentedHeaderViewCell *segmentedHeader = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (segmentedHeader == nil){
            [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
        }
        [segmentedHeader configureCell];
        return segmentedHeader;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    else {
            return 44.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static NSString *CellIdentifier;
    if (section == 0) {
        return nil;
    }
    else {
        CellIdentifier = @"Footer";
        CFVideoScreenFooterCell *footer = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [footer configureFooterCell];
        
        return footer;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    else {
        return 250.0;
    }
}

- (IBAction)postCommentPressed:(id)sender {
}
@end











