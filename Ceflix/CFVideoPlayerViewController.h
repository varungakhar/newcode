//
//  CFVideoPlayerViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 02/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFVideoListCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CFVideoPlayerViewDelegate;


// enum
typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionDirectionUp,
    UIPanGestureRecognizerDirectionDirectionDown,
    UIPanGestureRecognizerDirectionDirectionLeft,
    UIPanGestureRecognizerDirectionDirectionRight
};

@interface CFVideoPlayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (strong, nonatomic) NSDictionary *detailItem;
@property (nonatomic, weak) id<CFVideoPlayerViewDelegate> delegate;
@property (nonatomic)CGRect initialFirstViewFrame;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIView *onView;

// actions
- (IBAction)xButtonPressed:(id)sender;
- (IBAction)postCommentPressed:(id)sender;

// methods
- (void)configureView;

@end


/*
 * Protocol to expose CFVideoPlayerViewDelegate methods
 */
@protocol CFVideoPlayerViewDelegate <NSObject>

- (void)removeController;

@end
