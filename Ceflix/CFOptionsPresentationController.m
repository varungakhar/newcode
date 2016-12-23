//
//  CFOptionsPresentationController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 28/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFOptionsPresentationController.h"

@implementation CFOptionsPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if(self)
    {
        [self prepareDimmingView];
    }
    
    return self;
    
}

- (void)presentationTransitionWillBegin
{
    UIView* containerView = [self containerView];
    UIViewController* presentedViewController = [self presentedViewController];
    [dimmingView setFrame:[containerView bounds]];
    [dimmingView setAlpha:0.0];
    
    [containerView insertSubview:dimmingView atIndex:0];
    
    if([presentedViewController transitionCoordinator])
    {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [dimmingView setAlpha:1.0];
        } completion:nil];
    }
    else
    {
        [dimmingView setAlpha:1.0];
    }
}

- (void)dismissalTransitionWillBegin
{
    if([[self presentedViewController] transitionCoordinator])
    {
        [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [dimmingView setAlpha:0.0];
        } completion:nil];
    }
    else
    {
        [dimmingView setAlpha:0.0];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyle
{
    return UIModalPresentationOverFullScreen;
}

- (CGSize)sizeForChildContentContainer:(id <UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    return CGSizeMake(floorf(parentSize.width),
                      parentSize.height / 3.0);
}

- (void)containerViewWillLayoutSubviews
{
    [dimmingView setFrame:[[self containerView] bounds]];
    [[self presentedView] setFrame:[self frameOfPresentedViewInContainerView]];
}

- (BOOL)shouldPresentInFullscreen
{
    return YES;
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect presentedViewFrame = CGRectZero;
    CGRect containerBounds = [[self containerView] bounds];
    
    presentedViewFrame.size = [self sizeForChildContentContainer:(UIViewController<UIContentContainer> *)[self presentedViewController]
                                         withParentContainerSize:containerBounds.size];
    
     presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width;
    
    return presentedViewFrame;
    
}

@synthesize dimmingView;

- (void)prepareDimmingView
{
    dimmingView = [[UIView alloc] init];
    [dimmingView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    [dimmingView setAlpha:0.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
    [dimmingView addGestureRecognizer:tap];
}

- (void)dimmingViewTapped:(UIGestureRecognizer *)gesture
{
    if([gesture state] == UIGestureRecognizerStateRecognized)
    {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
}
@end








