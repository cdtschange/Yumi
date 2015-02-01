//
//  TopicReplyViewController.m
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "TopicReplyViewController.h"
#import "TopicReplyTableViewCell.h"
#import "UserUtils.h"
#import "DateUtils.h"
#import "ShareUtils.h"
static NSString *kTopicReplyTableViewCellIdentify = @"TopicReplyTableViewCell";

@interface TopicReplyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;

@end

@implementation TopicReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataWithCache:(BOOL)cache{
    __weak TopicReplyViewController *weakself = self;
    TopicReplyCommentsAPIData *data = [TopicReplyCommentsAPIData initWithTrid:self.trid];
    data.cachePolicy = cache? NSURLRequestReturnCacheDataElseLoad:NSURLRequestUseProtocolCachePolicy;
    NSURLSessionTask *task = [data requestWithSuccess:^(id responseObject) {
        TopicReplyCommentsAPIData *data = responseObject;
        [weakself dataArrayChanged:data.topicReplyComments];
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
    
    self.title = @"话题详情";
    
    [self.viewHeader setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.btnAddFriend.layer.cornerRadius = 3;
    self.btnAddFriend.layer.masksToBounds = YES;
    
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self loadData];
    
    [self.imgHead addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHead:)]];
}
-(void)loadData{
    [super loadData];
    self.lblName.text = self.uname;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[self.upic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.lblTime.text = [NSString stringWithFormat:@"%@发布", [DateUtils timeConvertToShort:[self.time intValue]]];
    self.lblPosition.text = self.position;
    self.lblContent.text = self.content;
    CGRect rectToFit = [self.lblContent.text boundingRectWithSize:CGSizeMake(self.lblContent.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    double height = rectToFit.size.height;
    self.viewHeader.height = 164 - 18 + height;
    self.tableView.tableHeaderView = self.viewHeader;
    [self.tableView reloadData];

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

- (IBAction)click_addFriend:(id)sender {
    [self routeToName:@"UserProfileViewController" params:@{@"uid":self.uid}];
}
- (IBAction)click_share:(id)sender {
    [[ShareUtils shared] shareWithText:@""];
}
- (IBAction)click_comment:(id)sender {
    __weak TopicReplyViewController *weakself = self;
    CommentViewController *vc = [UIViewController instanceByName:@"CommentViewController"];
    vc.block = ^(BOOL select, NSString *content) {
        if (select&&content.length>0) {
            NSURLSessionTask *task = [[CommentReplyTopicAPIData initWithTrid:self.trid content:content] requestWithSuccess:^(id responseObject) {
                [weakself reloadDataWithCache:NO];
            } failure:self.failureBlock];
            [self setNetworkStateOfTask:task];
        }
    };
    UINavigationController *nav = [[[self.navigationController class] alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)click_like:(id)sender {
    self.btnLike.selected = !self.btnLike.selected;
    int cnt = [[self.btnLike titleForState:UIControlStateNormal] intValue];
    if (self.btnLike.selected) {
        cnt++;
    }else{
        cnt--;
    }
    [self.btnLike setTitle:[NSString stringWithFormat:@"%d",cnt] forState:UIControlStateNormal];
}
-(void)tapHead:(UILongPressGestureRecognizer *)tapPress{
    [self routeToName:@"UserProfileViewController" params:@{@"uid":self.uid}];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopicReplyTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kTopicReplyTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    TopicReplyComment *tp = self.dataArray[indexPath.row];
    cell.replyComment = tp;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForCellWithIndexPath:indexPath];
}
- (CGFloat)heightForCellWithIndexPath:(NSIndexPath *)indexPath {
    TopicReplyComment *tp = self.dataArray[indexPath.row];
    CGRect rectToFit = [tp.text boundingRectWithSize:CGSizeMake(self.view.width-109, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    double height = rectToFit.size.height;
    return 92-17+height;
}


@end
