//
//  CFBannerCollectionViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 10/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFBannerCollectionViewCell.h"

@implementation CFBannerCollectionViewCell

- (void)configureCellForBanner:(NSDictionary *)dict {
    NSString *bannerImageURL = dict[@"url"];
    [self.bannerImage loadImageUsingUrlString:bannerImageURL];
}

@end
