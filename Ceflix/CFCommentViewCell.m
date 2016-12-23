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
    
    NSString *name=[NSString stringWithFormat:@"%@ %@",comment.firstName,comment.lastName];
    self.nameLabel.text=name;

    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",comment.userName];
    self.commentLabel.font=[UIFont systemFontOfSize:15.0f];
    
    CGFloat value=[UIScreen mainScreen].bounds.size.width-65;
    
    CGRect rect=[comment.comment boundingRectWithSize:CGSizeMake(value, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f
                                                                                                                                                                       ]} context:nil];
    
    
    self.commentLabel.frame=CGRectMake(self.commentLabel.frame.origin.x,self.commentLabel.frame.origin.y, value, rect.size.height);
    
    self.commentLabel.text = comment.comment;
    self.ageLabel.text = comment.timeAgo;
    [self.profileImageView loadImageUsingUrlString:comment.profilePic];
}

@end
