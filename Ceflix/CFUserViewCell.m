//
//  CFUserViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 25/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFUserViewCell.h"

@implementation CFUserViewCell


- (void)configureCellForUser:(CFUser *)user {
    [self.profilePicture loadImageUsingUrlString:user.userProfilePicture];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    
    NSString *nameOfUserText = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];
    
    self.nameOfUser.text = nameOfUserText;
    // self.numberOfFollowers.text =
}

- (IBAction)followPressed:(id)sender {
    [self.followButton setImage:[UIImage imageNamed:@"following button"] forState:UIControlStateNormal];
}
@end
