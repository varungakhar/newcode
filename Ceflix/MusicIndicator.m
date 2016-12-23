//
//  MusicIndicator.m
//  Ceflix
//
//  Created by Oluwatobi Omotayo on 1/29/16.
//  Copyright © 2016 Kindlebit Solution Pvt.Ltd. All rights reserved.
//

#import "MusicIndicator.h"
#import "UIConstants.h"

@implementation MusicIndicator

+ (instancetype)sharedInstance {
    static MusicIndicator *_sharedMusicIndicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicIndicator = [[MusicIndicator alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 44)];
    });
    
    return _sharedMusicIndicator;
}

@end
