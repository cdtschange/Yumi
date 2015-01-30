//
//  NavRootViewController.h
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "MLNavigationController.h"

@interface NavRootViewController : MLNavigationController

@end

@interface UIViewController (NavRootViewController)

// MLNavigationController能否手势返回, 默认返回YES
@property(nonatomic, assign) BOOL canDragBack;

// MLNavigationController的pan手势是否要捕获touch, 默认返回YES, 即捕获
- (BOOL)navigationControllerShouldRecieveTouch:(UITouch *)touch;

@end