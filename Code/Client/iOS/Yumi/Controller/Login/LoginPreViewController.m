//
//  RootViewController.m
//  G2R
//
//  Created by Wei Mao on 7/15/14.
//  Copyright (c) 2014 cdts. All rights reserved.
//

#import "LoginPreViewController.h"

@interface LoginPreViewController ()

@end

@implementation LoginPreViewController

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

- (IBAction)click_login:(id)sender {
    [self routeToName:@"LoginViewController" params:nil];
}
- (IBAction)click_register:(id)sender {
    [self routeToName:@"RegisterPreViewController" params:nil];
}


@end
