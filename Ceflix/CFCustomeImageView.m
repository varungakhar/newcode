//
//  CFCustomeImageView.m
//  Ceflix
//
//  Created by Tobi Omotayo on 24/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFCustomeImageView.h"

@implementation CFCustomeImageView

- (void)loadImageUsingUrlString:(NSString *)urlString {
    imageUrlString = urlString;
    NSURL *url = [NSURL URLWithString:urlString];
    self.image = nil;
    UIImage *imageFromCache = [imageCache objectForKey:urlString];
    if (imageFromCache) {
        self.image = imageFromCache;
        return;
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *imageToCache = [UIImage imageWithData:data];
            if (imageUrlString == urlString) {
                self.image = imageToCache;
            }
            [imageCache setObject:imageToCache forKey:urlString];
        });
    }] resume];
}

@end
