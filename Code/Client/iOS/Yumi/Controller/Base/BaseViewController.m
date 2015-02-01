//
//  BaseViewController.m
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "BaseViewController.h"
#import "ActivityHUD.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

-(void)initUIAndData{
    [super initUIAndData];
    [ActivityHUD setBackgroundDim:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.emptyView = [[EmptyDefaultView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height-240-120)/2, 320, 240)];
    self.emptyView.lblDescription.text = [self emptyTitle];
}

-(NSString *)emptyTitle{
    return TXT_Default_EmptyData;
}

-(void)initNavigationBar{
    [super initNavigationBar];
    [MyNavigationHelper setNavigationBarBgImage:self.navigationController.navigationBar];
}


-(void)showErrorTip:(NSError *)error{
    NSString *errorMsg = [YumiNetAPIData errorToString:error];
    [self showInfoTip:errorMsg];
}

@end
