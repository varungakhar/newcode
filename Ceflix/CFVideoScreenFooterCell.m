//
//  CFVideoScreenFooterCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 21/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFVideoScreenFooterCell.h"

@implementation CFVideoScreenFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)refreshButtonPressed:(id)sender {
}

- (void)configureFooterCell {
    [self.activityIndicator startAnimating];
}

@end
