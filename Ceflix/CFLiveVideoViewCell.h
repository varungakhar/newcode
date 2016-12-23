//
//  CFLiveVideoViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 25/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCeflixRemoteVideo.h"
#import "CFChannel.h"

@protocol CFLiveVideoViewCellDelegate;

@interface CFLiveVideoViewCell : UITableViewCell {
    UIImageView *imageView;
}

- (void)configureCellForLiveVideo:(CFCeflixRemoteVideo *)liveVideo;

/// The Video associated with this view
@property (nonatomic, strong) CFCeflixRemoteVideo *video;

/*! @name Delegate */
@property (nonatomic, weak) id <CFLiveVideoViewCellDelegate> delegate;

@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic) UIImage *image;

@end

/*!
 The protocol defines methods a delegate of a CFLiveVideoViewCell should implement.
 */
@protocol CFLiveVideoViewCellDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withVideo:(CFCeflixRemoteVideo *)video;
- (void)didClickOnOptionsAtIndex:(NSInteger)cellIndex withData:(id)data byButton:(UIButton *)button;

@end
