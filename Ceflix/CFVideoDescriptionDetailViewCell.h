//
//  CFVideoDescriptionDetailViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 15/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCeflixRemoteVideo.h"

@interface CFVideoDescriptionDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *videoDescriptionLabel;

- (void)configureCell:(CFCeflixRemoteVideo *)video;

@end
