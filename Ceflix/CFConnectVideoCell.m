//
//  CFConnectVideoCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 05/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFConnectVideoCell.h"

@implementation CFConnectVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForItem:(CFConnectTimelineItem *)item {
    if ([item.videoType  isEqual: @"1"]) {
        [self.videoStatusView setHidden:YES];
    }
    else {
        self.videoStatusLabel.text = @"Peter Ojo shared";
    }
    [self.profilePicture loadImageUsingUrlString:item.userData.userProfilePicture];
    self.profilePicture.layer.cornerRadius = self.videoThumbnail.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    
    // self.videoDurationLabel.text = item.videoData.duration
    [self.videoThumbnail loadImageUsingUrlString:item.videoData.thumbnailImageURL];
    
    NSString *nameOfUserButtonText = [NSString stringWithFormat:@"%@ %@", item.userData.userFirstName, item.userData.userLastName];
    [self.nameOfUserLabel setTitle:nameOfUserButtonText forState:UIControlStateNormal];
    
    if ([item.userData.userName isKindOfClass:[NSString class]]) {
        [self.usernameLabel setTitle:item.userData.userName forState:UIControlStateNormal];
    }
    self.videoDescriptionLabel.text = item.videoData.caption;
    self.numOfLikesLabel.text = item.videoData.likeCount;
    self.numOfViewsLabel.text = item.videoData.viewCount;
    self.numOfCommentsLabel.text = item.videoData.commentCount;
}

- (IBAction)optionsButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnOptionsAtIndex:withVideo:byButton:)]) {
        [self.delegate didClickOnOptionsAtIndex:_cellIndex withVideo:self.video byButton:self.optionsButton];
    }
}

- (IBAction)profilePictureButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withVideo:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withVideo:self.video];
    }
}

- (IBAction)shareButtonPressed:(id)sender {
}

- (IBAction)likeButtonPressed:(id)sender {
}

- (IBAction)commentButtonPressed:(id)sender {
}

@end
