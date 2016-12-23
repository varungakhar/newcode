//  AppDelegate.m
//  Ceflix
//
//  Created by Tobi Omotayo on 14/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "AppDelegate.h"
#import "CFAPIClient.h"
#import "RotatingNavigationController.h"
#import "STKAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "STPopupController.h"
#import "Chameleon.h"
#import "CFConnectViewController.h"


@interface AppDelegate ()

@property (nonatomic, copy) void (^completionHandler)();

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        NSLog(@"Requesting permission for push notifications..."); // iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"http://apix3x9.ceflix.org"];
    NSURL *endpointURL = [NSURL URLWithString:URLString];
    [CFAPIClient setSharedInstanceEndpoint:endpointURL];
    
    [application setMinimumBackgroundFetchInterval:30];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    
    NSLog(@"Registering device for push notification..."); // iOS 8
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    
    NSLog(@"Registration successful, bundle identifier: %@, mode: %@, device token: %@", [[NSBundle mainBundle] bundleIdentifier], [self modeString], deviceToken);
    NSUserDefaults *tokenID = [NSUserDefaults standardUserDefaults];
    [tokenID setObject:deviceToken forKey:@"CFDeviceToken"];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"Failed to register: %@", error);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo completionHandler:(nonnull void (^)())completionHandler {
    
    NSLog(@"Received push notification: %@, identifier: %@", userInfo, identifier); // iOS 8
    completionHandler();
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    
    NSLog(@"Received push notification: %@", userInfo); // iOS 7 and earlier
    
}

- (NSString *)modeString {
#if DEBUG
    return @"Development (sandbox)";
#else
    return @"Production";
#endif
}

#pragma mark - Background Networking

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    NSLog(@"%s identifier=%@", __PRETTY_FUNCTION__, identifier);
    
    self.completionHandler = completionHandler;
    
    // This will cause the VFMAPIClient to re-initialize and connect to the
    // background NSURLSession and handle the various delegate callbacks. It
    // will be responsible for invoking the stored completion handler once
    // all delegate callbacks have been delivered.
    [[CFAPIClient sharedInstance] beginTrackingReponseErrors];
}

#pragma mark - Instance Methods

- (void)invokeBackgroundTaskCompletionHandlerWithErrors:(NSArray *)errors {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.hasAction = NO;
        
        if (errors.count > 0) {
            notification.alertBody = @"One of more of your downloads failed";
        }
        else {
            notification.alertBody = @"Your downloads have completed";
        }
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        if (self.completionHandler != NULL) {
            self.completionHandler();
            self.completionHandler = NULL;
        }
    }];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%s Fetching videos in the background...", __PRETTY_FUNCTION__);
    
    [[CFAPIClient sharedInstance] fetchTimeLineItemsWithSuccess:^(NSArray *connectTimelineItems) {
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        UINavigationController *navigationController = (UINavigationController *)tabController.viewControllers[1];
        CFConnectViewController *connectViewController = (CFConnectViewController *)navigationController.topViewController;
        [connectViewController updateItems:connectTimelineItems];
        
        completionHandler(UIBackgroundFetchResultNewData);
    } failure:^(NSError *error) {
        NSLog(@"Unable to fetch /connect/timeline/userID in background: %@", error);
        completionHandler(UIBackgroundFetchResultFailed);
    }];
}

@end

















