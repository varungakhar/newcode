//
//  CFSegmentedHeaderViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 15/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFVideo.h"

@interface CFSegmentedHeaderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (void)configureCell;
@end
