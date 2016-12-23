//
//  CFVideoListCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 03/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCeflixRemoteVideo.h"


@protocol CFVideoListCellDelegate;

@interface CFVideoListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoDescription;
@property (weak, nonatomic) IBOutlet UILabel *videoViews;
- (IBAction)optionsButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (weak, nonatomic) IBOutlet UILabel *videoDuration;
- (void)configureCellForVideoList:(CFCeflixRemoteVideo *)video;

/*! @name Delegate */
@property (nonatomic, weak) id <CFVideoListCellDelegate> delegate;

@property (nonatomic, assign) NSInteger cellIndex;

@end

/*!
 The protocol defines methods a delegate of a CFVideoListCell should implement.
 */
@protocol CFVideoListCellDelegate <NSObject>

- (void)didClickOptionsAtIndex:(NSInteger)cellIndex withData:(id)data byButton:(UIButton *)button;

@end
