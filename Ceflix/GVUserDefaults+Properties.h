//
//  GVUserDefaults+Properties.h
//  GVUserDefaults
//
//  Created by Kevin Renskers on 18-12-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVUserDefaults.h"

 
 typedef NS_ENUM(NSInteger, MusicCycleType) {
 MusicCycleTypeLoopAll = 0,
 MusicCycleTypeLoopSingle = 1,
 MusicCycleTypeShuffle = 2,
 };

@interface GVUserDefaults (Properties)

 @property (nonatomic, copy) NSString *userLoginToken;
 @property (nonatomic, copy) NSString *userClientToken;
 @property (nonatomic, copy) NSNumber *currentUserId;
 @property (nonatomic, strong) NSDate *lastTimeShowLaunchScreenAd;
 @property (nonatomic, assign) MusicCycleType musicCycleType;
 @property (nonatomic, assign) BOOL shouldShowNotWiFiAlertView;
 @end

