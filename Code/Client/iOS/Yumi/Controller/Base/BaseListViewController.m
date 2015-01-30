//
//  BaseListViewController.m
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "BaseListViewController.h"
#import "ActivityHUD.h"

@interface BaseListViewController()

@property (assign, nonatomic) BOOL isRefresh;

@end

@implementation BaseListViewController

-(void)dealloc{
    self.dataArray = nil;
    [self.refreshLoadMoreView deallocWithCloseConnect];
    self.refreshLoadMoreView = nil;
}
-(NSString *)emptyTitle{
    return TXT_Default_EmptyData;
}
-(void)initUIAndData{
    [super initUIAndData];
    [ActivityHUD setBackgroundDim:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.emptyView = [[EmptyDefaultView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height-240-120)/2, 320, 240)];
    self.emptyView.lblDescription.text = [self emptyTitle];
    self.emptyView.hidden = YES;
    [self.listView addSubview:self.emptyView];
    if (IOS_7) {
        if ([self.listView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.listView;
            tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        }
    }
}

-(void)initNavigationBar{
    [super initNavigationBar];
    [MyNavigationHelper setNavigationBarBgImage:self.navigationController.navigationBar];
}

-(int)listLoadNumber{
    return 50;
}
-(int)listMaxNumber{
    return 500;
}
-(ListViewArrowStyle)arrowStyle{
    return ListViewArrowStyleGray;
}

-(void)showErrorTip:(NSError *)error{
    NSString *errorMsg = [YumiNetworkProvider errorToString:error];
    [self showInfoTip:errorMsg];
}

-(void)dataArrayChanged:(NSArray *)array{
#if kQuickTestNoData
    array = [NSArray new];
#endif
    [super dataArrayChanged:array];
    if (self.dataArray.count==0) {
        [self.emptyView.lblDescription setText:[self emptyTitle]];
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
}

@end