//
//  CFVideoChannelDetailViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 15/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCeflixRemoteVideo.h"
#import "CFCustomeImageView.h"

@interface CFVideoChannelDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
- (IBAction)subscribePressed:(id)sender;
@property (weak, nonatomic) IBOutlet CFCustomeImageView *channelProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *channelName;
@property (weak, nonatomic) IBOutlet UILabel *channelSubscribersLabel;

- (void)configureCell:(CFCeflixRemoteVideo *)video;

@end
