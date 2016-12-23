//
//  CFConnectViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 06/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A top-level view-controller that shows the list of videos in a user's timeline, also 
 * for tracking the state of in-flight upload.
 * Once an upload completes, the cell is removed from the underlying table-view.
 */
@interface CFConnectViewController : UITableViewController

- (void)updateItems:(NSArray *)connectTimelineItems;

@end
