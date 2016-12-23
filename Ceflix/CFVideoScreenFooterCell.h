//
//  CFVideoScreenFooterCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 21/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFVideoScreenFooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
- (IBAction)refreshButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (void)configureFooterCell;

@end
