//
//  CFLoginViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 16/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFLoginViewController.h"
#import "CFCeflixService.h"
#import "Reachability.h"

@interface CFLoginViewController ()
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;
@end

@implementation CFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.usernameTextField becomeFirstResponder];
    [self.loggingInActivityIndicator setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)dealloc {
    
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

// TODO: later replace this method with the actual service call  to login a user
- (void)doSomething {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // [self loginUserWithCredentials];
        [NSThread sleepForTimeInterval: 10];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loggingInActivityIndicator stopAnimating];
            [self.loggingInActivityIndicator setHidden:YES];
            [self.loginButton setHidden:NO];
            [self.delegate loginViewControllerSucceeded:self];
        });
    });
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self checkTextFieldForButtonState];
    return YES;
}

#pragma mark - Actions

- (IBAction)forgotPasswordPressed:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset Password" message:@"Enter the email address associated with your Ceflix Account. We will email you password reset instructions." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // add method to post the user email to the API service responsible for forgot password
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Email";
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)loginPressed:(id)sender {
    
    // do check for internet connection first here if not connected show alert
    if (self.internetActive) {
        if (self.hostActive) {
            
            [self.loginButton setHidden:YES];
            [self.loggingInActivityIndicator setHidden:NO];
            [self.loggingInActivityIndicator startAnimating];
            
            [self loginUserWithCredentials];
            // [self doSomething];
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

- (IBAction)backgroundTouchDown:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)closePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

- (void)checkTextFieldForButtonState {
    BOOL usernameReady = self.usernameTextField.text.length > 0;
    BOOL passwordReady = self.passwordTextField.text.length > 0;
    
    self.loginButton.enabled = usernameReady && passwordReady;
}

#pragma mark - Service Calls

- (void)loginUserWithCredentials {
    
    NSString *email = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    __weak typeof(self) weakSelf = self;
    
    CFCeflixService *service = [CFCeflixService sharedInstance];
    [service signInWithEmail:email password:password success:^(CFUser *user) {
        [weakSelf.loggingInActivityIndicator stopAnimating];
        [weakSelf.loggingInActivityIndicator setHidden:YES];
        [weakSelf.loginButton setHidden:NO];
        [weakSelf.delegate loginViewControllerSucceeded:weakSelf];
    } failure:^(NSError *error) {
        [weakSelf.loggingInActivityIndicator stopAnimating];
        [weakSelf.loggingInActivityIndicator setHidden:YES];
        [weakSelf.loginButton setHidden:NO];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to Sign in" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"%@", error.localizedDescription);
    }];
}

@end








