//
//  DismissSegue.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
