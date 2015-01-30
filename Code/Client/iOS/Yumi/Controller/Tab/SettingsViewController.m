//
//  SettingsViewController.m
//  Yumi
//
//  Created by Mao on 1/27/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end

@implementation SettingsViewController

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
    self.title = @"设置";
    self.btnLogout.layer.cornerRadius = 3;
    self.btnLogout.layer.masksToBounds = YES;
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}

- (IBAction)click_logout:(id)sender {
    [[AccountEntity shared] clear];
    UINavigationController *nav = self.navigationController;
    [self routeBack];
    UIViewController *vc = [UIViewController instanceByName:@"LoginViewController"];
    [nav pushViewController:vc animated:YES];
}

@end
