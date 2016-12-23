//
//  CFEditProfileViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 24/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFEditProfileViewController.h"

@interface CFEditProfileViewController ()

@end

@implementation CFEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)donePressed:(id)sender {
    
    // Add code to save the user information online when pressed. Also replace this with loading animation on the right bar.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)choosePhotoPressed:(id)sender {
    
    // display Action sheet to choose photo, take one or cancel.
    
}
@end
