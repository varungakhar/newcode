//
//  CFDrawFrameRectViewClass.h
//  Ceflix
//
//  Created by Tobi Omotayo on 16/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CFDrawFrameRectViewClass : UIView

@property (nonatomic) IBInspectable NSInteger lineWidth;
@property (nonatomic) IBInspectable UIColor *fillColor;

@end
