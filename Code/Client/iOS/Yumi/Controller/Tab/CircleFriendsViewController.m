//
//  CircleFriendsViewController.m
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "CircleFriendsViewController.h"

@interface CircleFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CircleFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 1336);
}

-(void)initUIAndData{
    [super initUIAndData];
    self.title = @"语密圈";
    [self loadData];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}

@end
