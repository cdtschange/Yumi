//
//  RegisterPreViewController.m
//  G2R
//
//  Created by Wei Mao on 7/18/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "RegisterPreViewController.h"
#import "UserProvider.h"
#import "MHTextField.h"
#import "UIViewController+TextFieldDelegate.h"

@interface RegisterPreViewController ()

@property (weak, nonatomic) IBOutlet MHTextField *txtMobile;
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;
//@property (strong, nonatomic) G2RNetworkProvider *provider;
@property (weak, nonatomic) IBOutlet UIView *viewMobile;

@end

@implementation RegisterPreViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUIAndData{
    [super initUIAndData];
    [self.txtMobile becomeFirstResponder];
    self.title = @"注册账号";
    self.viewMobile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewMobile.layer.borderWidth = 0.5;
    self.viewMobile.layer.cornerRadius = 3;
    self.viewMobile.layer.masksToBounds = YES;
    self.btnNextStep.layer.cornerRadius = 3;
    self.btnNextStep.layer.masksToBounds = YES;
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_NextStep:(id)sender {
    [self.txtMobile resignFirstResponder];
    NSString *mobile = [self.txtMobile.text replaceAll:@" " with:@""];
    if (![UserProvider validMobile:mobile]) {
        [self showInfoTip:@"手机号无效"];
        return;
    }
//    __weak RegisterPreViewController *weakself = self;
//    self.provider = [G2RNetworkProvider new];
//    [self.provider userExistForValue:mobile type:UserExistTypeMobile];
//    self.provider.statusBlock = self.statusBlock;
//    [self.provider requestWithSuccess:^(id responseObject) {
//        UserExistData *data = responseObject;
//        if (data.isexist) {
//            [weakself showInfoTip:@"手机号已注册"];return;
//        }
//        [weakself routeToName:@"RegisterViewController" params:@{@"mobile":mobile}];
//    } failure:self.failureBlock];
    [self routeToName:@"RegisterAuthCodeViewController" params:@{@"mobile":mobile}];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = [self mobileValidWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    return result;
}

@end
