//
//  CFBannerTableViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 10/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFBannerTableViewCell.h"

@implementation CFBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCollectionData:(NSArray *)collectionData {
    [_collectionView setCollectionData:collectionData];
}

@end
