//
//  SpeechDetailAnimator.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/28/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "SpeechDetailAnimator.h"
#import "SpeechDetailTableViewController.h"
#import "SpeechesCollectionViewController.h"

@implementation SpeechDetailAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //////////////////////////////////////
    // Prepare our data
    //////////////////////////////////////
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    fromViewController = [fromViewController isKindOfClass:[UINavigationController class]] ? [(UINavigationController*)fromViewController topViewController] : fromViewController;
    
    toViewController = [toViewController isKindOfClass:[UINavigationController class]] ? [(UINavigationController*)toViewController topViewController] : toViewController;
    
    SpeechesCollectionViewController *listViewController = (SpeechesCollectionViewController*)([fromViewController isKindOfClass:[SpeechesCollectionViewController class]] ? fromViewController : toViewController);
    
    SpeechDetailTableViewController *detailedViewController = (SpeechDetailTableViewController*)([fromViewController isKindOfClass:[SpeechDetailTableViewController class]] ? fromViewController : toViewController);
    
    UINavigationController* listNavigationController = listViewController.navigationController;
    UINavigationController* detailedNavigationController = detailedViewController.navigationController;
    
    UIImageView* detailedImageView = detailedViewController.imageView;
    UIImageView* listImageView = listViewController.selectedImageView;
    
    UIView* containerView = [transitionContext containerView];
    
    if ([detailedViewController isEqual:toViewController] ) { // we are presenting
        
        // add it new view controler
        [containerView addSubview:detailedNavigationController ? detailedNavigationController.view : detailedViewController.view];
        
        // Force the constriant to be updated
        [containerView updateConstraintsIfNeeded];
        [containerView layoutIfNeeded];
        
        
        // Copy the source and destination image and blend with them
        UIView* detailedImageViewCopy = [detailedImageView snapshotViewAfterScreenUpdates:YES];
        UIView* listImageViewCopy = [listImageView snapshotViewAfterScreenUpdates:YES];
        
        // Make the starting frame = the listImageView positon
        detailedImageViewCopy.frame = [listImageView convertRect:listImageView.bounds toView:listViewController.view];
        listImageViewCopy.frame = detailedImageViewCopy.frame;
        
        
        // Create a background white to simulate fade effect
        UIView* fadeOutView = [[UIView alloc] initWithFrame:listViewController.view.bounds];
        fadeOutView.backgroundColor = [UIColor whiteColor];
        fadeOutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        fadeOutView.alpha = 0.0f;
        
    
        // Add the sub views to the from View controller
        // we didn't use the container view in order for the image to come from behind
        // the navigation bar
        [listViewController.view addSubview:fadeOutView];
        [listViewController.view addSubview:detailedImageViewCopy];
        [listViewController.view addSubview:listImageViewCopy];
        
        // initial the distiatnion view controller will be hidden
        detailedNavigationController.view.alpha = 0.0;
        detailedViewController.view.alpha = 0.0;
        listImageView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //[UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            detailedImageViewCopy.frame = [detailedImageView convertRect:detailedImageView.bounds toView:listViewController.view];
            listImageViewCopy.frame = detailedImageViewCopy.frame;
            detailedImageViewCopy.alpha = 1.0;
            listImageViewCopy.alpha = 0.0;
            
            fadeOutView.alpha = 1.0;
            detailedNavigationController.view.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                detailedViewController.view.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                // Clean up, return everything to original
                listImageView.alpha = 1.0f;
                listViewController.view.alpha = 1.0;
                [fadeOutView removeFromSuperview];
                [listImageViewCopy removeFromSuperview];
                [detailedImageViewCopy removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
        }];
    }else {
        // We are dimissing
        
        // Copy the source and destination image and blend with them
        UIView* detailedImageViewCopy = [detailedImageView snapshotViewAfterScreenUpdates:NO];
        UIView* listImageViewCopy = [listImageView snapshotViewAfterScreenUpdates:NO];
        
        detailedImageViewCopy.frame = [detailedImageView convertRect:detailedImageView.bounds toView:detailedImageView.superview.superview];
        
        listImageViewCopy.frame = detailedImageViewCopy.frame;
        
        // Create a background white to simulate fade effect
        UIView* fadeOutView = [[UIView alloc] initWithFrame:detailedViewController.view.bounds];
        fadeOutView.backgroundColor = [UIColor whiteColor];
        fadeOutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        [detailedViewController.view addSubview:fadeOutView];
        [detailedViewController.view addSubview:listImageViewCopy];
        [detailedViewController.view addSubview:detailedImageViewCopy];
        
    
        fadeOutView.alpha = 0.0f;
        detailedImageView.alpha = 0.0f;
        //listViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{

            listImageViewCopy.frame = [listImageView convertRect:listImageView.bounds toView:detailedViewController.view];
            detailedImageViewCopy.frame = listImageViewCopy.frame;
            
            detailedImageViewCopy.alpha = 0.0;
            
            fadeOutView.alpha = 1.0;
            
        }completion:^(BOOL finished) {
            
            listViewController.view.alpha = 1.0;
            
            [UIView animateWithDuration:0.3 animations:^{
    
                detailedNavigationController.view.alpha = 0.0f;
                
                
            } completion:^(BOOL finished) {
                
                // Clean up, return everything to original
                [containerView insertSubview:detailedViewController.view aboveSubview:listNavigationController.view];
                
                detailedNavigationController.view.alpha = 1.0;
                [fadeOutView removeFromSuperview];
                [listImageViewCopy removeFromSuperview];
                [detailedImageViewCopy removeFromSuperview];
                [transitionContext completeTransition:YES];
                
            }];
        }];

    }
    
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}


@end
