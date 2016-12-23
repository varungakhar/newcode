//
//  CFChannelListCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 06/12/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCustomeImageView.h"
#import "CFChannel.h"

@interface CFChannelListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CFCustomeImageView *channelThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *channelName;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfVideosLabel;

- (IBAction)subscribePressed:(id)sender;

- (void)configureCell:(CFChannel *)channel;

@end
