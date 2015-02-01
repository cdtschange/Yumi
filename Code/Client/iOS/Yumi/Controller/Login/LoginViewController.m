//
//  OAuthLoginViewController.m
//  WandaKTV
//
//  Created by Wei Mao on 11/23/12.
//  Copyright (c) 2012 WandaKtvInc.. All rights reserved.
//
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserProvider.h"
#import "MHTextField.h"

@interface LoginViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIView *viewMobile;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}
#pragma mark - Base
-(void)initUIAndData{
    [super initUIAndData];
    self.title = @"登录";
    self.txtName.text = [AccountEntity shared].mobile;
    self.viewMobile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewMobile.layer.borderWidth = 0.5;
    self.viewMobile.layer.cornerRadius = 3;
    self.viewMobile.layer.masksToBounds = YES;
    self.viewPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewPassword.layer.borderWidth = 0.5;
    self.viewPassword.layer.cornerRadius = 3;
    self.viewPassword.layer.masksToBounds = YES;
    self.btnLogin.layer.cornerRadius = 3;
    self.btnLogin.layer.masksToBounds = YES;
    self.btnRegister.layer.cornerRadius = 3;
    self.btnRegister.layer.masksToBounds = YES;
}
-(void)initNavigationBar{
    [super initNavigationBar];
    if (self.navigationController.viewControllers.count>1) {
        [self setBackLeftButtonOnNavBar];
    }
}

#pragma mark - interface build action
- (IBAction)login:(id)sender {
    [self.txtName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    __weak LoginViewController *weakself = self;
    NSURLSessionTask *task = [[UserProvider shared] userLoginForUserName:self.txtName.text passwd:self.txtPassword.text success:^(id responseObject) {
        //TODO
        [weakself showInfoTip:TXT_Login_LoginSuccess];
        [weakself routeBack];
        } failure:self.failureBlock];
    [self setNetworkStateOfTask:task];
}
- (IBAction)regist:(id)sender {
    [self routeToName:@"RegisterPreViewController" params:nil];
}
- (IBAction)click_loginProblem:(id)sender {
}



@end
