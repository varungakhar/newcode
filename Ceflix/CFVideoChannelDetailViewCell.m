//
//  CFVideoChannelDetailViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 15/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFVideoChannelDetailViewCell.h"

@implementation CFVideoChannelDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subscribePressed:(id)sender {
    /*
    if ([NSUserDefaults]) {
        <#statements#>
    }
     */
}
- (void)configureCellForLiveStream:(CFCeflixRemoteVideo *)video
{
    self.subscribeButton.hidden=YES;
    
    self.channelSubscribersLabel.hidden=YES;
    
    self.channelName.text = video.eventDesc;
    
      [self.channelProfileImage loadImageUsingUrlString:video.thumbnail];
    self.channelProfileImage.layer.cornerRadius = self.channelProfileImage.frame.size.width / 2;
    self.channelProfileImage.clipsToBounds = YES;
}

- (void)configureCell:(CFCeflixRemoteVideo *)video {
    self.channelName.text = video.channelName;
    self.channelSubscribersLabel.text = @"2,789 subscribers";
    [self.channelProfileImage loadImageUsingUrlString:video.channelProfilePicture];
    self.channelProfileImage.layer.cornerRadius = self.channelProfileImage.frame.size.width / 2;
    self.channelProfileImage.clipsToBounds = YES;
}


@end
