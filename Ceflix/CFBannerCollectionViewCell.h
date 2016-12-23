//
//  CFBannerCollectionViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 10/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFBanner.h"
// #import "Ceflix-Swift.h"
#import "CFCustomeImageView.h"

@interface CFBannerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet CFCustomeImageView *bannerImage;

- (void)configureCellForBanner:(NSDictionary *)dict;

@end
