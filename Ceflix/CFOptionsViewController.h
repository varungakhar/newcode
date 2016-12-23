//
//  CFOptionsViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 28/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFLiveVideoViewCell.h"

@interface CFOptionsViewController : UIViewController {
    UIVisualEffectView *backgroundView;
    UIVisualEffectView *foregroundContentView;
    
    UIBlurEffect *blurEffect;
    UIImageView *imageView;
    
    CFLiveVideoViewCell *currentVideoView;
}

@property (nonatomic) CFLiveVideoViewCell *videoView;

@end
