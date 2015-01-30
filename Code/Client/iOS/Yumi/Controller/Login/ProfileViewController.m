//
//  ProfileViewController.m
//  Yumi
//
//  Created by Mao on 12/29/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txfNick;
@property (weak, nonatomic) IBOutlet UITextField *txfID;
@property (weak, nonatomic) IBOutlet UITextField *txfBirthday;
@property (weak, nonatomic) IBOutlet UITextField *txfMajor;
@property (weak, nonatomic) IBOutlet UITextField *txfLanguage;
@property (weak, nonatomic) IBOutlet UITextField *txfLanguageLevel;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UIButton *btnHead;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_head:(id)sender {
}
- (IBAction)click_ok:(id)sender {
    if (self.isFirst&&self.isFirst.boolValue) {
        [AccountEntity shared].uid = @"15";
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self routeBack];
    }
}
- (void)click_skip:(id)sender {
    [AccountEntity shared].uid = @"15";
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)initUIAndData{
    [super initUIAndData];
    self.scrollView.contentSize = CGSizeMake(320, 520);
    self.btnOK.layer.cornerRadius = 3;
    self.btnOK.layer.masksToBounds = YES;
    [self loadData];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    if (self.isFirst&&self.isFirst.boolValue) {
        self.navigationItem.rightBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeSkip target:self action:@selector(click_skip:)];
    }else{
        [self setBackLeftButtonOnNavBar];
    }
}
-(void)loadData{
    [super loadData];
    if (self.isFirst&&self.isFirst.boolValue) {
        self.title = @"填写基本资料";
    }else{
        self.title = @"详细资料";
        self.btnHead.isRounded = YES;
        [self.btnHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:[AccountEntity shared].picsrc]]  placeholderImage:[UIImage imageNamed:IMG_HEAD_DEFAULT] forState:UIControlStateNormal];
    }
}
@end
