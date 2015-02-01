//
//  TopicListViewController.m
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "TopicListViewController.h"
#import "TopicTableViewCell.h"

static NSString *kTopicTableViewCellIdentify = @"TopicTableViewCell";

@interface TopicListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myTopicArray;

@end

@implementation TopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataWithCache:(BOOL)cache{
    __weak TopicListViewController *weakself = self;
    TopicsAPIData *data = [TopicsAPIData initWithStart:self.dataIndex num:self.listLoadNumber];
    data.cachePolicy = cache? NSURLRequestReturnCacheDataElseLoad:NSURLRequestUseProtocolCachePolicy;
    NSURLSessionTask *task = [data requestWithSuccess:^(id responseObject) {
        TopicsAPIData *data = responseObject;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:data.topics];
        [weakself dataArrayChanged:arr];
        NSURLSessionTask *task = [[MyTopicsAPIData init] requestWithSuccess:^(id responseObject) {
            MyTopicsAPIData *data2 = responseObject;
            NSMutableArray *arr2 = [NSMutableArray arrayWithArray:data2.topics];
            weakself.myTopicArray = arr2;
            [weakself dataArrayChanged:arr];
            [weakself.tableView reloadData];
        } failure:weakself.listFailureBlock];
        [weakself setListNetworkStateOfTask:task];
    } failure:weakself.listFailureBlock];
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
    self.title = @"话题";
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    self.dataIndex = 0;
    [self reloadDataWithCache:YES];
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
    if (self.myTopicArray.count==0) {
        if (section==0) {
            return self.dataArray.count;
        }
    }else{
        if (section==0) {
            return self.myTopicArray.count;
        }else if (section==1) {
            return self.dataArray.count;
        }
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.myTopicArray.count==0) {
        return 2;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopicTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kTopicTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
    }
    Topic *topic;
    if (indexPath.section==0&&self.myTopicArray.count>0) {
        topic = self.myTopicArray[indexPath.row];
    }else{
        topic = self.dataArray[indexPath.row];
    }
    cell.topic = topic;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Topic *topic;
    if (indexPath.section==0&&self.myTopicArray.count>0) {
        topic = self.myTopicArray[indexPath.row];
    }else{
        topic = self.dataArray[indexPath.row];
    }
    [self routeToName:@"TopicDetailViewController" params:@{@"tid":topic.tid}];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32)];
    view.backgroundColor = RGBCOLOR(250,250,250);
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 31, self.view.width, 1)];
    line1.backgroundColor = RGBCOLOR(228,229,230);
    line2.backgroundColor = RGBCOLOR(228,229,230);
    [view addSubview:line1];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 32)];
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.font = [UIFont systemFontOfSize:14];
    lblTitle.text = @"全部话题";
    if (self.myTopicArray.count==0) {
        if (section<1) {
            [view addSubview:line2];
            [view addSubview:lblTitle];
        }
    }else{
        if (section==0) {
            lblTitle.text = @"我参加的话题";
        }
        if (section<2) {
            [view addSubview:line2];
            [view addSubview:lblTitle];
        }
    }
    return view;
}


@end
