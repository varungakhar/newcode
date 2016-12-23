//
//  CFChannelTopViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 30/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFChannelTopViewCell.h"

@interface CFChannelTopViewCell ()

@end

@implementation CFChannelTopViewCell

- (void)configureCellForChannelTopView:(NSDictionary *)dict {
    self.subscribeButton.clipsToBounds = YES;
    
    self.channelName.text = [dict objectForKey:@"channel"];
    self.channelDescription.text = [dict objectForKey:@"description"];
    
    NSString *videoCountText = [NSString stringWithFormat:@"%@ Videos • ", [dict objectForKey:@"VideoCount"]];
    self.channelVideoCount.text = videoCountText;
    
    NSString *imageURLString = [dict objectForKey:@"profilepic"];
    NSLog(@"%@", imageURLString);
    [self.channelImage loadImageUsingUrlString:imageURLString];
    
    NSString *subcribersCountText = [NSString stringWithFormat:@"%@ Subscribers", [dict objectForKey:@"SubscriberCount"]];
    self.channelSubscribersCount.text = subcribersCountText;
}

- (IBAction)subscribePressed:(id)sender {
}
@end
