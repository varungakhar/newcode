//
//  CFVideoTitleDetailViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 15/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCeflixRemoteVideo.h"

@interface CFVideoTitleDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hideDescriptionIcon;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoViewsAndAgeLabel;

- (void)configureCell:(CFCeflixRemoteVideo *)video;
-(void)configureCellForLiveStream:(CFCeflixRemoteVideo *)video;

@end
