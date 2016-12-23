//
//  CFHomeVideoCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 24/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCustomeImageView.h"


@protocol CFHomeVideoViewCellDelegate;

@interface CFHomeVideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CFCustomeImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UILabel *homeVideoTitle;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (weak, nonatomic) IBOutlet UIButton *channelName;
@property (weak, nonatomic) IBOutlet CFCustomeImageView *homeVideoImage;
@property (weak, nonatomic) IBOutlet UILabel *homeVideoDescription;
@property (weak, nonatomic) IBOutlet UILabel *numberWatching;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)profileImageButtonPressed:(id)sender;
- (IBAction)optionsButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

- (void)configureCellForHomeVideo:(NSDictionary *)homeVideo;

/// The Video associated with this view
@property (nonatomic, strong) NSDictionary *video;

/*! @name Delegate */
@property (nonatomic, weak) id <CFHomeVideoViewCellDelegate> delegate;

@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, assign) NSInteger cellSection;

@end

/*!
 The protocol defines methods a delegate of a CFHomeVideoViewCell should implement.
 */
@protocol CFHomeVideoViewCellDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex inSection:(NSInteger)cellSection withVideo:(NSDictionary *)video;
- (void)didClickOnOptionsAtIndex:(NSInteger)cellIndex withData:(id)data byButton:(UIButton *)button;
@end
