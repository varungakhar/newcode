//
//  CFSignupViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 19/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFSignupViewControllerDelegate;

@class Reachability;

@interface CFSignupViewController : UIViewController <UITextFieldDelegate> {
    Reachability *internetReachable;
    Reachability *hostReachable;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
- (IBAction)joinPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *signingUpActivityIndicator;

@property (nonatomic, weak) id<CFSignupViewControllerDelegate> delegate;

- (void)checkNetworkStatus:(NSNotification *)notice;

@end

@protocol CFSignupViewControllerDelegate <NSObject>

- (void)signupViewControllerSucceeded:(CFSignupViewController *)signupViewController;

@end

