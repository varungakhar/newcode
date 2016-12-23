//
//  CFHomeViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 23/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFHomeVideoCell.h"

@interface CFHomeViewController : UITableViewController <CFHomeVideoViewCellDelegate> {
    id<UIViewControllerTransitioningDelegate> transitioningDelegate;
}

@end
