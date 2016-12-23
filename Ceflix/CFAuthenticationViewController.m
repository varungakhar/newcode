//
//  CFAuthenticationViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 15/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFAuthenticationViewController.h"

#import "AppDelegate.h"
#import "CFCeflixService.h"

NSString *const serverURL = @"http://api.ceflix.org/api";

@implementation CFAuthenticationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions
/*
- (IBAction)didTapSignIn:(id)sender {
    self.authenticationLabel.text = @"Signing In...";
    
    __weak typeof(self) weakSelf = self;
    NSURL *URL = [NSURL URLWithString:@"http://api.ceflix.org/api"];
    
    [self showWaitUI];
    
    [[CFCeflixService sharedInstance] signInWithEmail:self.usernameField.text password:self.passwordField.text serverURL:URL success:^(CFUser *user) {
        [weakSelf hideWaitUI];
        [weakSelf.delegate authenticationViewControllerSucceeded:weakSelf];
    } failure:^(NSError *error) {
        [weakSelf hideWaitUI];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Sign-in" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}
*/
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self checkTextFieldsForButtonState];
    return YES;
    
}

#pragma mark - Helpers

- (void)showWaitUI {
    self.signInButton.hidden = YES;
    self.waitView.hidden = NO;
}

- (void)hideWaitUI {
    self.signInButton.hidden = NO;
    self.waitView.hidden = YES;
}

- (void)checkTextFieldsForButtonState {
    BOOL usernameReady = self.usernameField.text.length > 0;
    BOOL passwordReady = self.passwordField.text.length > 0;

    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"^http(s)?://" options:0 error:nil];
    NSRange range = NSMakeRange(0, serverURL.length);
    BOOL serverReady = [regexp firstMatchInString:serverURL options:0 range:range] != nil;
    self.signInButton.enabled = usernameReady && passwordReady && serverReady;
}

@end


























