//
//  CFCustomeImageView.h
//  Ceflix
//
//  Created by Tobi Omotayo on 24/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFCustomeImageView : UIImageView {
    NSCache *imageCache;
    NSString *imageUrlString;
}
- (void)loadImageUsingUrlString:(NSString *)urlString;

@end
