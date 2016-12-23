//
//  CFLiveVideoViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 25/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFLiveVideoViewCell.h"
#import "NSString+ConvertCase.h"
#import "CFCustomeImageView.h"

@interface CFLiveVideoViewCell ()
@property (weak, nonatomic) IBOutlet CFCustomeImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UILabel *liveVideoTitle;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (weak, nonatomic) IBOutlet UIButton *channelName;
@property (weak, nonatomic) IBOutlet CFCustomeImageView *liveVideoImage;
@property (weak, nonatomic) IBOutlet UILabel *liveVideoDescription;
@property (weak, nonatomic) IBOutlet UILabel *numberWatching;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)profileImageButtonPressed:(id)sender;
- (IBAction)optionsButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


@end

@implementation CFLiveVideoViewCell

- (void)configureCellForLiveVideo:(CFCeflixRemoteVideo *)liveVideo {
    self.liveVideoTitle.text = liveVideo.title;
    
    NSString *channelButtonLabeltext = [NSString stringWithFormat:@"%@ >", liveVideo.channelName];
    [self.channelName setTitle:channelButtonLabeltext forState:UIControlStateNormal];
    
    self.liveVideoDescription.text = liveVideo.videoDescription;
    if ([liveVideo.channelProfilePicture isKindOfClass:[NSString class]]) {
        [self.profileImage loadImageUsingUrlString:liveVideo.channelProfilePicture];
    }
    else {
        // set a default profile image for those without profile image
    }
    if ([liveVideo.thumbnail isKindOfClass:[NSString class]]) {
        [self.liveVideoImage loadImageUsingUrlString:liveVideo.thumbnail];
    }
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
}
- (void)configureCellForLiveStream:(CFCeflixRemoteVideo *)liveVideo
{
    
    
    
    
    NSString *name=[NSString stringWithFormat:@"%@ %@",liveVideo.firstname,liveVideo.lastname];
    
    
    self.liveVideoTitle.text = name;
    
  
    
    NSString *channelButtonLabeltext = [NSString stringWithFormat:@"@%@ >", liveVideo.username];
    
    [self.channelName setTitle:channelButtonLabeltext forState:UIControlStateNormal];
    
    self.liveVideoDescription.text = liveVideo.eventDesc;
    if ([liveVideo.channelProfilePicture isKindOfClass:[NSString class]]) {
        [self.profileImage loadImageUsingUrlString:liveVideo.channelProfilePicture];
    }
    else {
        // set a default profile image for those without profile image
    }
    
    
    if ([liveVideo.thumbnail isKindOfClass:[NSString class]]) {
    [self.liveVideoImage loadImageUsingUrlString:liveVideo.thumbnail];
    }
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    
    NSString *string=[NSString stringWithFormat:@"%@ views",liveVideo.views];
    
    
    self.numberWatching.text=string;
    
    self.ageLabel.text=liveVideo.timeago;
    
    
}

- (IBAction)profileImageButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withVideo:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withVideo:self.video];
    }
}

- (IBAction)optionsButtonPressed:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnOptionsAtIndex:withData:byButton:)]) {
        [self.delegate didClickOnOptionsAtIndex:_cellIndex withData:@"Some other cell data/property" byButton:self.optionsButton];
    }
}

- (UIImage *)image {
    return [imageView image];
}

@end












