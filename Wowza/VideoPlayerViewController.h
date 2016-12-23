//
//  VideoPlayerViewController.h
//  SDKSampleApp
//
//  This code and all components (c) Copyright 2015-2016, Wowza Media Systems, LLC. All rights reserved.
//  This code is licensed pursuant to the BSD 3-Clause License.
//

#import <UIKit/UIKit.h>
#import "CFCeflixService.h"
#import "CFAPIClient.h"
#import "CommentView.h"
@interface VideoPlayerViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *switchcamerabtn;
    
    IBOutlet UILabel *linelbl,*startbroadcastlbl;
    IBOutlet UITextField *streamnametext;
    IBOutlet UIView *footerview;
    IBOutlet UIButton *optionBtn;
    UIAlertController *alertcontroller;
    IBOutlet UIImageView *livenowimg;
    NSString *eventid;
    UIImage *thumbimage;
    NSInteger maxduration;
    CommentView *cview;
    IBOutlet UIButton *globeicon;
    IBOutlet UILabel *privacylbl;
    NSString *privacy;

    NSString *shareurl;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

