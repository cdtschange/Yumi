//
//  AddUserViewController.m
//  Yumi
//
//  Created by Mao on 15/1/18.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "AddUserViewController.h"

@interface AddUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txfReason;

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUIAndData{
    [super initUIAndData];
    self.title = @"添加好友";
    [self loadData];
}
-(void)loadData{
    [super loadData];
    [self.txfReason becomeFirstResponder];
}

-(void)initNavigationBar{
    [super initNavigationBar];
    self.navigationItem.leftBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeCancel target:self action:@selector(click_Cancel:)];
    self.navigationItem.rightBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeSend target:self action:@selector(click_OK:)];
}


- (void)click_OK:(id)sender {
    [self.txfReason resignFirstResponder];
    [self routeBack];
    if (self.block) {
        self.block(YES,self.txfReason.text);
        self.block = nil;
    }
}
- (void)click_Cancel:(id)sender {
    [self.txfReason resignFirstResponder];
    [self routeBack];
    if (self.block) {
        self.block(NO,@"");
        self.block = nil;
    }
}


@end
