//
//  CFMeFooterViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 04/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMeFooterViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *loginStatus;
@property (weak, nonatomic) IBOutlet UILabel *joinMessage;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *noSignedUserImage;

@end
