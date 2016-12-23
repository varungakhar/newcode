//
//  Video.m
//  Ceflix
//
//  Created by Tobi Omotayo on 20/06/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFVideo.h"

static NSString * const CFVideoTitleKey = @"title";
static NSString * const CFVideoDescriptionKey = @"videoDescription";
static NSString *const CFVideoCaptionKey = @"caption";

@interface CFVideo()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *videoDescription;
@property (nonatomic, copy, readwrite) NSString *caption;

@end

@implementation CFVideo

- (instancetype)initWithTitle:(NSString *)title videoDescription:(NSString *)videoDescription
{
    if ((self = [super init])) {
        self.title = title;
        self.videoDescription = videoDescription;
    }
    return self;
}

- (instancetype)initWithCaption:(NSString *)caption {
    if ((self = [super init])) {
        self.caption = caption;
    }
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // return [self initWithTitle:[aDecoder decodeObjectForKey:CFVideoTitleKey] videoDescription:[aDecoder decodeObjectForKey:CFVideoDescriptionKey]];
    
    return [self initWithCaption:[aDecoder decodeObjectForKey:CFVideoCaptionKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // [aCoder encodeObject:self.title forKey:CFVideoTitleKey];
    // [aCoder encodeObject:self.videoDescription forKey:CFVideoDescriptionKey];
    
    [aCoder encodeObject:self.caption forKey:CFVideoCaptionKey];
}

@end










