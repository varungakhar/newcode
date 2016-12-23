//
//  CFUserViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 25/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCustomeImageView.h"
#import "CFUser.h"

@interface CFUserViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CFCustomeImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameOfUser;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFollowers;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
- (IBAction)followPressed:(id)sender;

- (void)configureCellForUser:(CFUser *)user;

@end
