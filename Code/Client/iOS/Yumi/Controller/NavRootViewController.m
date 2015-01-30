//
//  NavRootViewController.m
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "NavRootViewController.h"
#import <objc/runtime.h>
#import "RootViewController.h"

@interface NavRootViewController ()

@end

@implementation NavRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
    [self.navigationBar setBarStyle:(UIBarStyleDefault)];
}

- (BOOL)canDragBack
{
    if (self.viewControllers.count>0) {
        if ([self.viewControllers[0] isKindOfClass:[RootViewController class]]) {
            if (self.viewControllers.count <= 2) {
                return NO;
            }
            return self.topViewController.canDragBack;
        }else{
            if (self.viewControllers.count <= 1) {
                return NO;
            }
            return self.topViewController.canDragBack;
        }
    }
    return NO;
}

// overwrite
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!self.canDragBack || [touch.view isKindOfClass:[UIControl class]] ||
        ![self.topViewController navigationControllerShouldRecieveTouch:touch]) {
        return NO;
    }
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
        return NO;
    }
    return YES;
}

@end

@implementation UIViewController (NavRootViewController)
const void *UIViewControllerCanDragBackKey = "UIViewControllerCanDragBackKey";
- (BOOL)canDragBack
{
    id object = objc_getAssociatedObject(self, UIViewControllerCanDragBackKey);
    if (object) {
        return [object boolValue];
    }
    return YES;
}

- (void)setCanDragBack:(BOOL)canDragBack
{
    objc_setAssociatedObject(self, UIViewControllerCanDragBackKey, @(canDragBack), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)navigationControllerShouldRecieveTouch:(UITouch *)touch
{
    return YES;
}

@end
