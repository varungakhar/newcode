//
//  CFConnectVideoProgressCell.m
//  Ceflix
//
//  Created by Tobi Omotayo on 24/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFConnectVideoProgressCell.h"

#import "CFConnectVideo.h"
#import "CFVideo.h"
#import "CFConnectVideoUpload.h"

CGFloat CFConnectVideoProgressCellHeight = 60.0f;

@interface CFConnectVideoProgressCell ()

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *pauseResumeImage;

@end

@implementation CFConnectVideoProgressCell

- (void)dealloc {
    self.upload = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupContentView];
}

- (void)setupContentView {
    self.imageView.clipsToBounds = YES;
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.contentView addSubview:self.progressView];
    
    self.pauseResumeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause-icon"]];
    [self.pauseResumeImage sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectInset(CGRectMake(0, 0, CFConnectVideoProgressCellHeight, CFConnectVideoProgressCellHeight), 5, 5);
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    textLabelFrame.origin.y = 0;
    textLabelFrame.size.height = 44;
    self.textLabel.frame = textLabelFrame;
    
    self.progressView.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame),
                                         CGRectGetMaxY(self.textLabel.frame),
                                         CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(self.textLabel.frame) - 8,
                                         CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(self.textLabel.frame));
}

#pragma mark - KVO 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ((object == self.upload) && [keyPath isEqualToString:@"progress"]) {
        self.progressView.progress = self.upload.progress;
        if (self.progressView.progress == 1.0) {
            self.progressView.hidden = YES;
        }
        else {
            self.progressView.hidden = NO;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Properties 

- (void)setUpload:(CFConnectVideoUpload *)upload {
    if (_upload != upload) {
        [_upload removeObserver:self forKeyPath:@"progress"];
        
        _upload = upload;
        [_upload addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
        
        self.accessoryView = nil;
        self.textLabel.text = @"Sending"; // upload.video.title;
        self.imageView.image = upload.thumbnailImage;
    }
}

- (void)setShowsPauseResumeButton:(BOOL)showsPauseResumeButton {
    _showsPauseResumeButton = showsPauseResumeButton;
    if (showsPauseResumeButton) {
        self.accessoryView = self.pauseResumeImage;
    }
    else {
        self.accessoryView = nil;
    }
}

@end










