//
//  CFVideoDescriptionDetailViewCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 15/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFVideoDescriptionDetailViewCell.h"

@implementation CFVideoDescriptionDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(CFCeflixRemoteVideo *)video {
    self.videoDescriptionLabel.text = video.videoDescription;
}

@end
