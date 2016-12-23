//
//  CFCommentViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 21/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFCommentViewCell.h"

@implementation CFCommentViewCell

- (void)configureCellForComment:(CFComment *)comment {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.usernameLabel.text = comment.userName;
    self.commentLabel.text = comment.comment;
    self.ageLabel.text = comment.timeAgo;
    [self.profileImageView loadImageUsingUrlString:comment.profilePic];
}

@end
