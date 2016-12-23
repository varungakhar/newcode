//
//  CFTabBarController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 29/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFTabBarController.h"

@implementation CFTabBarController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 2) {
        
        UINavigationController *selectedNav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        UIViewController *currentVC = selectedNav.visibleViewController;
        if([currentVC isMemberOfClass:NSClassFromString(@"CFLiveViewController")])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
        }
    }
    return YES;
}
@end
