//
//  CFMeViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 22/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFLoginViewController.h"
#import "CFSignupViewController.h"
#import "CFUser.h"

@interface CFMeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CFLoginViewControllerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
