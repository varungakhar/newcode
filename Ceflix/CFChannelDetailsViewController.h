//
//  CFChannelDetailsViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 30/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFVideoListCell.h"

@interface CFChannelDetailsViewController : UITableViewController <CFVideoListCellDelegate>

@property (strong, nonatomic) NSString *channelID;

@end
