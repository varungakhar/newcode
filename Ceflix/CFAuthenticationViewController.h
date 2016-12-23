//
//  CFAuthenticationViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 15/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFAuthenticationViewControllerDelegate;

@interface CFAuthenticationViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *authenticationLabel;
@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, weak) id<CFAuthenticationViewControllerDelegate> delegate;

- (IBAction)didTapSignIn:(id)sender;

@end

@protocol CFAuthenticationViewControllerDelegate

- (void)authenticationViewControllerSucceeded:(CFAuthenticationViewController *)authVC;

@end

