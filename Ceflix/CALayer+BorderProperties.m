//
//  CALayer+BorderProperties.m
//  Ceflix
//
//  Created by Tobi Omotayo on 17/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CALayer+BorderProperties.h"

@implementation CALayer (BorderProperties)

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    
    self.borderUIColor = (__bridge UIColor *)(borderUIColor.CGColor);
    
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:(__bridge CGColorRef _Nonnull)(self.borderUIColor)];
}

@end
