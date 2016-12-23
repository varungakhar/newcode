//
//  AppDelegate.h
//  Ceflix
//
//  Created by Tobi Omotayo on 14/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property(nonatomic,retain)UINavigationController *navigationController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) STKAudioPlayer *audioPlayer;

/**
* Invokes the completion handler given to the application by the
* -application:handleEventsForBackgroundURLSession:completionHandler:
* method.
* @param errors An array of NSError instances or nil (or empty) if there are none
*/
- (void)invokeBackgroundTaskCompletionHandlerWithErrors:(NSArray *)errors;

@end
