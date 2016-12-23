//
//  CFVideoTitleDetailViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 15/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFVideoTitleDetailViewCell.h"

@implementation CFVideoTitleDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellForLiveStream:(CFCeflixRemoteVideo *)video
{
    self.videoTitle.text = video.eventDesc;
    NSString *videoAge = video.timeago;
    NSString *videoViewsAndAgeLabelText = [NSString stringWithFormat:@"%@ Views • %@", video.views, videoAge];
    self.videoViewsAndAgeLabel.text = videoViewsAndAgeLabelText;
    
}

- (void)configureCell:(CFCeflixRemoteVideo *)video {
    self.videoTitle.text = video.title;
    NSString *videoAge = @"2w Ago";
    NSString *videoViewsAndAgeLabelText = [NSString stringWithFormat:@"%@ Views • %@", video.views, videoAge];
    self.videoViewsAndAgeLabel.text = videoViewsAndAgeLabelText;
}

@end
