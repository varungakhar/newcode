//
//  CFScrollView.m
//  Ceflix
//
//  Created by Tobi Omotayo on 26/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFScrollView.h"

typedef enum : NSUInteger {
    Width,
    Height,
    Both,
    None,
    // Dynamic = ((CGFloat)width, CGFloat height)
} SizeMatching;

@interface CFScrollView ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, assign) IBInspectable SizeMatching sizeMatching;

@end

@implementation CFScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.contentView.superview != self) {
        [self addSubview:_contentView];
    }
    
    CGSize size = _contentView.bounds.size;
    self.sizeMatching = (SizeMatching)Width;
    switch (self.sizeMatching) {
        case Width:
            size.width = self.bounds.size.width;
            break;
        case Height: size.height = self.bounds.size.height;
            break;
        case Both:
            size.width = self.bounds.size.width;
            size.height = self.bounds.size.height;
            break;
        case None:
            break;
            
        default:
            break;
    }
    CGFloat x = 0.0, y = 0.0;
    CGPoint origin = {x, y};
    CGRect aRect = {origin, size};
    _contentView.frame = aRect;
    self.contentSize = size;
    
}

@end
