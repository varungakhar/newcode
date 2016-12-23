//
//  CFLoginViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 16/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFLoginViewControllerDelegate;

@class Reachability;

@interface CFLoginViewController : UIViewController <UITextFieldDelegate, UIViewControllerTransitioningDelegate> {
    Reachability *internetReachable;
    Reachability *hostReachable;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)forgotPasswordPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginPressed:(id)sender;
- (IBAction)closePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loggingInActivityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, weak) id<CFLoginViewControllerDelegate> delegate;

- (void)checkNetworkStatus:(NSNotification *)notice;

/**
 * The background was touched 
 * @param sender The UIControl sender of the event
 */
- (IBAction)backgroundTouchDown:(id)sender; // could change this to a swipe down gestureRecognizer with animation for hiding the keyboard
@end

@protocol CFLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerSucceeded:(CFLoginViewController *)loginViewController;

@end
