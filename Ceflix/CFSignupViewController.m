//
//  CFSignupViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 19/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFSignupViewController.h"
#import "CFCeflixService.h"
#import "Reachability.h"

@interface CFSignupViewController ()
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;
@end

@implementation CFSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.usernameTextField becomeFirstResponder];
    [self.signingUpActivityIndicator setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.bottomConstraint.constant = keyboardSize.height;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.bottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
}


#pragma mark - Helper Methods

#pragma mark - Helper Methods

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
        }
    }
}

- (void)checkTextFieldForButtonState {
    BOOL usernameReady = self.usernameTextField.text.length > 0;
    BOOL passwordReady = self.passwordTextField.text.length > 0;
    
    self.joinButton.enabled = usernameReady && passwordReady;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self checkTextFieldForButtonState];
    
    return YES;
}


#pragma mark - Actions

- (IBAction)joinPressed:(id)sender {
    if (self.internetActive) {
        if (self.hostActive) {
            [self.joinButton setHidden:YES];
            
            [self.signingUpActivityIndicator setHidden:NO];
            [self.signingUpActivityIndicator startAnimating];
            
            // [self signupUserWithCredentials];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:@"Can't connect to Ceflix right now." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:okay];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please check your connection and try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Service Calls

/*
- (void)signupUserWithCredentials {
    NSString *email = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    __weak typeof(self) weakSelf = self;
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service registerNewUserWithUsername:<#(NSString *)#> password:<#(NSString *)#> firstName:<#(NSString *)#> lastName:<#(NSString *)#> email:<#(NSString *)#> gender:<#(NSString *)#> phoneNumber:<#(NSString *)#> country:<#(NSString *)#> deviceToken:<#(NSString *)#> deviceType:<#(NSString *)#> appID:<#(NSString *)#> success:<#^(CFUser *user)success#> failure:<#^(NSError *error)failure#>]
}
*/

@end







