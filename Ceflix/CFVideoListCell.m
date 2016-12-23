//
//  CFVideoListCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 03/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFVideoListCell.h"
// #import "ceflix-Swift.h"
#import "CFCustomeImageView.h"

@interface CFVideoListCell ()
@property (weak, nonatomic) IBOutlet CFCustomeImageView *videoThumbnail;
@end

@implementation CFVideoListCell

- (void)configureCellForVideoList:(CFCeflixRemoteVideo *)video {
    self.videoTitle.text = video.title;
    self.videoDuration.clipsToBounds = YES;
    self.videoDescription.text = video.videoDescription;
    
    if ([video.thumbnail isKindOfClass:[NSString class]]) {
        [self.videoThumbnail loadImageUsingUrlString:video.thumbnail];
    }
}

- (IBAction)optionsButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOptionsAtIndex:withData:byButton:)]) {
        [self.delegate didClickOptionsAtIndex:_cellIndex withData:@"Some other cell data/property" byButton:self.optionsButton];
    }
}

@end
