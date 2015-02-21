//
//  CommentTopicReplyViewController.m
//  Yumi
//
//  Created by Mao on 1/9/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txvContent;

@end

@implementation CommentViewController

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
    self.title = @"写评论";
    [self.txvContent becomeFirstResponder];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    self.navigationItem.leftBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeCancel target:self action:@selector(click_Cancel:)];
    self.navigationItem.rightBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeSend target:self action:@selector(click_OK:)];
}
- (void)click_OK:(id)sender {
    [self.txvContent resignFirstResponder];
    [self routeBack];
    if (self.block) {
        self.block(YES,self.txvContent.text);
        self.block = nil;
    }
}
- (void)click_Cancel:(id)sender {
    [self.txvContent resignFirstResponder];
    [self routeBack];
    if (self.block) {
        self.block(NO,@"");
        self.block = nil;
    }
}

@end
