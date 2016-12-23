//
//  CFConnectVideoProgressCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 24/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFConnectVideoUpload;

extern CGFloat CFConnectVideoProgressCellHeight;

/**
 * A UITableViewCell for displaying the progress of a video upload or 
 * Instances of this cell track the progress of an upload using KVO.
 */
@interface CFConnectVideoProgressCell : UITableViewCell

@property (nonatomic, strong) CFConnectVideoUpload *upload;
@property (nonatomic, assign) BOOL showsPauseResumeButton;

@end
