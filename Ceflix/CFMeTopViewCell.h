//
//  CFMeTopViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 24/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFUser.h"

@interface CFMeTopViewCell : UITableViewCell

- (void)configureCellForMeTopView:(CFUser *)user;
@end
