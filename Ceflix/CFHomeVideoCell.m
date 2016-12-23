//
//  CFHomeVideoCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 24/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFHomeVideoCell.h"


@implementation CFHomeVideoCell

- (void)configureCellForHomeVideo:(NSDictionary *)homeVideo {
    self.homeVideoTitle.text = homeVideo[@"videos_title"];
    
    // set Live tag visibilit based on the isLive boolean
    if ([homeVideo[@"isLive"] boolValue]) {
        self.durationLabel.text = @"LIVE";
    }
    // set channel name to the button
    NSString *channelButtonLabelText = [NSString stringWithFormat:@"%@ >", homeVideo[@"channelName"]];
    [self.channelName setTitle:channelButtonLabelText forState:UIControlStateNormal];
    
    // set discription label
    self.homeVideoDescription.text = homeVideo[@"description"];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    if ([homeVideo[@"channelProfilePicture"] isKindOfClass:[NSString class]]) {
        [self.profileImage loadImageUsingUrlString:homeVideo[@"channelProfilePicture"]];
    }
    else {
        // set a default profile image for those without profile image
    }
    if ([homeVideo[@"thumbnail"] isKindOfClass:[NSString class]]) {
        [self.homeVideoImage loadImageUsingUrlString:homeVideo[@"thumbnail"]];
    }
    
}

- (IBAction)profileImageButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:inSection:withVideo:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex inSection:_cellSection withVideo:self.video];
    }
}

- (IBAction)optionsButtonPressed:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnOptionsAtIndex:withData:byButton:)]) {
        [self.delegate didClickOnOptionsAtIndex:_cellIndex withData:@"Some other cell data/property" byButton:self.optionsButton];
    }
}

@end
