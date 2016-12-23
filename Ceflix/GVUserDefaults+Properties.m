//
//  GVUserDefaults+Properties.m
//  GVUserDefaults
//
//  Created by Kevin Renskers on 18-12-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVUserDefaults+Properties.h"

@implementation GVUserDefaults (Properties)
@dynamic userLoginToken;
@dynamic userClientToken;
@dynamic currentUserId;
@dynamic lastTimeShowLaunchScreenAd;
@dynamic musicCycleType;
@dynamic shouldShowNotWiFiAlertView;

- (NSDictionary *)setupDefaults
{
    return @{
             @"shouldShowNotWiFiAlertView":@YES
             };
}

@end
