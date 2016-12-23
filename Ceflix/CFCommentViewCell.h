//
//  CFCommentViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 21/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFComment.h"
#import "CFCustomeImageView.h"

@interface CFCommentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CFCustomeImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

- (void)configureCellForComment:(CFComment *)comment;

@end
