//
//  CFEditProfileViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 24/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFEditProfileViewController : UITableViewController
- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
- (IBAction)choosePhotoPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
