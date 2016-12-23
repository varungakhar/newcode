//
//  Video.h
//  Ceflix
//
//  Created by Tobi Omotayo on 20/06/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A simple model of a video, regardless of where it may exist
 */
@interface CFVideo : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *videoDescription;
@property (nonatomic, copy, readonly) NSString *caption;

- (instancetype)initWithTitle:(NSString *)title
             videoDescription:(NSString *)videoDescription;

- (instancetype)initWithCaption:(NSString *)caption;

@end


