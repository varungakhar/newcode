//
//  CFConnectVideoCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 05/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCustomeImageView.h"
#import "CFConnectTimelineItem.h"

@protocol CFConnectVideoCellDelegate;

@interface CFConnectVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *videoStatusView;
@property (weak, nonatomic) IBOutlet UILabel *videoStatusLabel;
@property (weak, nonatomic) IBOutlet CFCustomeImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;

@property (weak, nonatomic) IBOutlet UIButton *nameOfUserLabel; // this guys is actually a button not a label
@property (weak, nonatomic) IBOutlet UIButton *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet CFCustomeImageView *videoThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *videoDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *numOfViewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfResharesLabel;

@property (weak, nonatomic) IBOutlet UILabel *numOfLikesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;

- (void)configureCellForItem:(CFConnectTimelineItem *)item;

@property (nonatomic, weak) id <CFConnectVideoCellDelegate> delegate;
@property (nonatomic, assign) NSInteger cellIndex;
// @property (nonatomic, assign) NSInteger cellSection;
@property (nonatomic, strong) CFConnectVideo *video;

- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)commentButtonPressed:(id)sender;
- (IBAction)optionsButtonPressed:(id)sender;
- (IBAction)profilePictureButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end

@protocol CFConnectVideoCellDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withVideo:(CFConnectVideo *)video;
- (void)didClickOnOptionsAtIndex:(NSInteger)cellIndex withVideo:(CFConnectVideo *)video byButton:(UIButton *)button;

@end
