//
//  CFOptionsViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 28/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFOptionsViewController.h"

@interface CFOptionsViewController ()

@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) CIImage *baseCIImage;
@property (nonatomic, strong) CIFilter *colorControlsFilter;
@property (nonatomic, strong) CIFilter *hueAdjustFilter;

@end

@implementation CFOptionsViewController {
    dispatch_queue_t processingQueue;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    foregroundContentView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blurEffect]];
    backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    [self configureViews];
    
}

- (void)configureCIObjects {
    if (!self.context) {
        self.context = [CIContext contextWithOptions:nil];
    }
    
    self.baseCIImage = [CIImage imageWithCGImage:[[[self videoView] image] CGImage]];
}

- (void)setVideoView:(CFLiveVideoViewCell *)videoView {
    if (currentVideoView != videoView) {
        currentVideoView = videoView;
        
        [self configureCIObjects];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup
{
    imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    processingQueue = dispatch_queue_create("image processing queue", DISPATCH_QUEUE_SERIAL);
}

- (void)configureViews {
    // [imageView setImage:[[self photoView] image]];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    
    [backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [foregroundContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [[self view] addSubview:backgroundView];
    [[self view] addSubview:foregroundContentView];
    
    
    [[self view] addSubview:imageView];
    

}

@end













