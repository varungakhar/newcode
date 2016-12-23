//
//  UIView+BorderColor.m
//  Ceflix
//
//  Created by Tobi Omotayo on 16/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "UIView+BorderColor.h"

@implementation UIView (BorderColor)

@dynamic borderColor, borderWidth, cornerRadius;

- (void)setBorderColor:(UIColor *)borderColor {
    
    [self.layer setBorderColor:borderColor.CGColor];
    
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    [self.layer setBorderWidth:borderWidth];
    
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    [self.layer setCornerRadius:cornerRadius];
    
}

@end
