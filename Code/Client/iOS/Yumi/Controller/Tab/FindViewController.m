//
//  FindViewController.m
//  Yumi
//
//  Created by Mao on 12/29/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "FindViewController.h"
#import "FindTableViewCell.h"
#import "UIView+MGBadgeView.h"

static NSString *kFindTableViewCellIdentify = @"FindTableViewCell";

@interface FindViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) NSArray *source;
@property (weak, nonatomic) IBOutlet UIButton *btnTopic1;
@property (weak, nonatomic) IBOutlet UIButton *btnTopic2;
@property (weak, nonatomic) IBOutlet UIButton *btnTopic3;
@property (weak, nonatomic) IBOutlet UIButton *btnTopic4;
@property (strong, nonatomic) NSArray *topics;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataWithCache:(BOOL)cache{
    __weak FindViewController *weakself = self;
    TopicsAPIData *data = [TopicsAPIData initWithStart:0 num:4];
    data.cachePolicy = cache? NSURLRequestReturnCacheDataElseLoad:NSURLRequestUseProtocolCachePolicy;
    NSURLSessionTask *task = [data requestWithSuccess:^(id responseObject) {
        TopicsAPIData *data = responseObject;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:data.topics];
        weakself.topics = arr;
        if (arr.count>0) {
            Topic *t = arr[0];
            NSString *str = [NSString stringWithFormat:@"#%@#",t.title];
            [weakself.btnTopic1 setTitle:str forState:UIControlStateNormal];
        }
        if (arr.count>1) {
            Topic *t = arr[1];
            NSString *str = [NSString stringWithFormat:@"#%@#",t.title];
            [weakself.btnTopic2 setTitle:str forState:UIControlStateNormal];
        }
        if (arr.count>2) {
            Topic *t = arr[2];
            NSString *str = [NSString stringWithFormat:@"#%@#",t.title];
            [weakself.btnTopic3 setTitle:str forState:UIControlStateNormal];
        }
        if (arr.count>3) {
            Topic *t = arr[3];
            NSString *str = [NSString stringWithFormat:@"#%@#",t.title];
            [weakself.btnTopic4 setTitle:str forState:UIControlStateNormal];
        }
        [weakself.tableView reloadData];
    } failure:self.failureBlock];
    [self setNetworkStateOfTask:task];
}
-(WaterViewType)listType{
    return WaterRefreshTypeNone;
}
-(UIScrollView *)listView{
    return self.tableView;
}
-(void)initUIAndData{
    [super initUIAndData];
    
    self.source = @[
  @{@"title":@"语伴圈",@"url":@"CircleFriendsViewController",@"image":@"icon_find_circle"},
  @{@"title":@"附近可能认识的人",@"url":@"NearUserViewController",@"image":@"icon_find_near"},
  @{@"title":@"发现话题",@"info":@"发现热门好的话题",@"url":@"TopicListViewController",@"image":@"icon_find_topic"},
  @{@"title":@"寻找群组",@"info":@"发现感兴趣的群组",@"image":@"icon_find_group"},
  @{@"title":@"语谜活动",@"info":@"发现好玩的活动",@"image":@"icon_find_activity"}];
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.tableHeaderView = self.viewHeader;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    self.dataIndex = 0;
    [self dataArrayChanged:self.source];
    [self.tableView reloadData];
    [self reloadDataWithCache:YES];

}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
}
-(void)initNavigationBar{
    [super initNavigationBar];
}
- (IBAction)click_btnTopic1:(id)sender {
    if (self.topics.count>0) {
        Topic *t = self.topics[0];
        [self routeToName:@"TopicDetailViewController" params:@{@"tid":t.tid}];
    }
}
- (IBAction)click_btnTopic2:(id)sender {
    if (self.topics.count>1) {
        Topic *t = self.topics[1];
        [self routeToName:@"TopicDetailViewController" params:@{@"tid":t.tid}];
    }
}
- (IBAction)click_btnTopic3:(id)sender {
    if (self.topics.count>2) {
        Topic *t = self.topics[2];
        [self routeToName:@"TopicDetailViewController" params:@{@"tid":t.tid}];
    }
}
- (IBAction)click_btnTopic4:(id)sender {
    if (self.topics.count>3) {
        Topic *t = self.topics[3];
        [self routeToName:@"TopicDetailViewController" params:@{@"tid":t.tid}];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFindTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kFindTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
    }
    
    cell.badgeView.hidden = YES;
    cell.lblTitle.badgeView.position = MGBadgePositionCenterRight;
    [cell.lblTitle setTranslatesAutoresizingMaskIntoConstraints:YES];
    NSDictionary *obj;
    if (indexPath.section==0) {
        obj = self.dataArray[indexPath.row];
        cell.lblTitle.text = obj[@"title"];
        if (indexPath.row==0) {
            cell.lblTitle.badgeView.badgeValue = @"9";
            cell.badgeView.left = 100;
        }else if (indexPath.row==1) {
            cell.lblTitle.badgeView.badgeValue = @"1";
            cell.badgeView.left = 200;
        }
    }else if (indexPath.section==1) {
        obj = self.dataArray[indexPath.row+2];
        cell.lblTitle.text = obj[@"title"];
        cell.lblTitle.badgeView.badgeValue = @"";
    }else if (indexPath.section==2) {
        obj = self.dataArray[indexPath.row+4];
        cell.lblTitle.text = obj[@"title"];
        cell.lblTitle.badgeView.badgeValue = @"";
    }
    if (obj[@"info"]&&[obj[@"info"] length]>0) {
        cell.lblTitle.top = 8;
        cell.lblDescription.hidden = NO;
        cell.lblDescription.text = obj[@"info"];
    }else{
        cell.lblTitle.top = 15;
        cell.lblDescription.hidden = YES;
    }
    cell.imgPic.image = [UIImage imageNamed:obj[@"image"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *obj;
    if (indexPath.section==0) {
        obj = self.dataArray[indexPath.row];
    }else if (indexPath.section==1) {
        obj = self.dataArray[indexPath.row+2];
    }else if (indexPath.section==2) {
        obj = self.dataArray[indexPath.row+4];
    }
    if ([obj objectForKey:@"url"]) {
        [self routeToName:obj[@"url"] params:nil];
    }else{
        [self showInfoTip:@"此功能暂未开放，敬请期待"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    view.backgroundColor = RGBCOLOR(250,250,250);
    return view;
}


@end
