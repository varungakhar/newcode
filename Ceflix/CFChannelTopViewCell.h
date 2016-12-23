//
//  CFChannelTopViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 30/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFChannel.h"
// #import "Ceflix-Swift.h"
#import "CFCustomeImageView.h"

@interface CFChannelTopViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CFCustomeImageView *channelImage;
@property (weak, nonatomic) IBOutlet UILabel *channelName;
@property (weak, nonatomic) IBOutlet UILabel *channelVideoCount;
@property (weak, nonatomic) IBOutlet UILabel *channelSubscribersCount;
@property (weak, nonatomic) IBOutlet UILabel *channelDescription;
@property (weak, nonatomic) IBOutlet UILabel *channelWebsiteURL;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
- (IBAction)subscribePressed:(id)sender;

- (void)configureCellForChannelTopView:(NSDictionary *)dict;
@end
