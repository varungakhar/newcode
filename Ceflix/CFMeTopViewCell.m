//
//  CFMeTopViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 24/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFMeTopViewCell.h"
#import "CFCustomeImageView.h"

@interface CFMeTopViewCell ()
@property (weak, nonatomic) IBOutlet CFCustomeImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFollowers;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *followStatus;

@end

@implementation CFMeTopViewCell

- (void)configureCellForMeTopView:(CFUser *)user {
    NSString *usernameText = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];
    self.usernameLabel.text = usernameText;
    /*
    self.numberOfLikes.text = user.userLikeCount ;
    self.numberOfFollowers.text = user.userFollowersCount;
    self.numberOfFollowing.text = user.userFolloweesCount;
    */
    if ([user.userBio isKindOfClass:[NSString class]]) {
        self.infoLabel.text = user.userBio;
    }
    self.locationLabel.text = user.userCountry;
    [self.profileImage loadImageUsingUrlString:user.userProfilePicture];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    if (!user.userFollowsYou) {
        [self.followStatus setHidden:YES];
    }
    
}

@end
