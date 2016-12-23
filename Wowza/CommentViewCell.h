//
//  CommentViewCell.h
//  Ceflix
//
//  Created by KindleBit on 12/12/16.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCustomeImageView.h"
@interface CommentViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *username,*timelbl;
@property (strong,nonatomic) IBOutlet CFCustomeImageView *userimage;
@property (strong,nonatomic) IBOutlet UILabel *commentlbl;
@end
