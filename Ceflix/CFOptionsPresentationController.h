//
//  CFOptionsPresentationController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 28/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFOptionsPresentationController : UIPresentationController {
    UIView *dimmingView;
}

@property (readonly) UIView *dimmingView;

@end
