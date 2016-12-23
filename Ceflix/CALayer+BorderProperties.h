//
//  CALayer+BorderProperties.h
//  Ceflix
//
//  Created by Tobi Omotayo on 17/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CALayer (BorderProperties)

// This assigns CGColor to borderColor
@property (nonatomic, assign) IBInspectable UIColor *borderUIColor;

@end
