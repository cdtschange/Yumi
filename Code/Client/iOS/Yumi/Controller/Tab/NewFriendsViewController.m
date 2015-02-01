//
//  NewFriendsViewController.m
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "FriendTableViewCell.h"

static NSString *kFriendTableViewCellIdentify = @"NewFriendTableViewCell";

@interface NewFriendsViewController ()<NewFriendTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataWithCache:(BOOL)cache{
    __weak NewFriendsViewController *weakself = self;
    UserRequestsAPIData *data = [UserRequestsAPIData init];
    data.cachePolicy = cache? NSURLRequestReturnCacheDataElseLoad:NSURLRequestUseProtocolCachePolicy;
    NSURLSessionTask *task = [data requestWithSuccess:^(id responseObject) {
        UserRequestsAPIData *data = responseObject;
        [weakself dataArrayChanged:data.users];
        [weakself.tableView reloadData];
    } failure:self.listFailureBlock];
    [self setListNetworkStateOfTask:task];
}
-(WaterViewType)listType{
    return WaterRefreshTypeOnlyRefresh;
}
-(UIScrollView *)listView{
    return self.tableView;
}
-(void)initUIAndData{
    [super initUIAndData];
    self.title = @"新的朋友";
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    self.dataIndex = 0;
    [self reloadDataWithCache:NO];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self reloadDataWithCache:!isRefresh];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.delegate = self;
    }
    User *user = self.dataArray[indexPath.row];
    cell.user = user;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = self.dataArray[indexPath.row];
    [self routeToName:@"UserProfileViewController" params:@{@"uid":user.uid}];
}
-(void)cell_clickAddForCell:(NewFriendTableViewCell *)cell sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __weak User *user = self.dataArray[indexPath.row];
    __weak NewFriendsViewController *weakself = self;
    NSURLSessionTask *task = [[AcceptUserAPIData initWithTuid:user.uid] requestWithSuccess:^(id responseObject) {
        user.state = 0;
        [weakself.tableView reloadData];
    } failure:self.failureBlock];
    [weakself setNetworkStateOfTask:task];
}

@end
