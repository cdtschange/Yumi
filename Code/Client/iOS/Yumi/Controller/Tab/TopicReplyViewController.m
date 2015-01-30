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
@property (strong, nonatomic) YumiNetworkProvider *provider;
@property (strong, nonatomic) YumiNetworkProvider *commentProvider;
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
            weakself.commentProvider = [YumiNetworkProvider new];
            [weakself.commentProvider commentReplyTopicForTrid:weakself.trid content:content];
            weakself.commentProvider.statusBlock = weakself.statusBlock;
            [weakself.commentProvider requestWithSuccess:^(id responseObject) {
                [weakself loadData];
            } failure:^(NSError *error) {
                weakself.failureBlock(error);
            }];
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
    [self.lblContent setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.btnAddFriend.layer.cornerRadius = 3;
    self.btnAddFriend.layer.masksToBounds = YES;
    __weak TopicReplyViewController *weakself = self;
    self.provider = [YumiNetworkProvider new];
    [self.provider setCompletionBlockWithSuccess:^(id responseObject) {
        TopicReplyCommentsData *data = responseObject;
        [weakself dataArrayChanged:data.topicReplyComments];
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        weakself.listFailureBlock(error);
    }];
    self.provider.statusBlock = self.listStatusBlock;
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.viewHeader removeFromSuperview];
    [self loadData];
    self.lblName.text = self.uname;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:self.upic]]];
    self.lblTime.text = [NSString stringWithFormat:@"%@发布", [DateUtils timeConvertToShort:[self.time intValue]]];
    self.lblPosition.text = self.position;
    
    self.lblContent.width = 297;
    self.lblContent.height = 33;
    self.lblContent.numberOfLines = 0;
    self.lblContent.text = self.content;
    [self.lblContent sizeToFit];
    
    
    double height = weakself.lblContent.height;
    height = fmax(height, 33);
    if (height>33) {
        weakself.viewHeader.height = 184 + height-33;
    }
    self.tableView.tableHeaderView = self.viewHeader;
    [weakself.tableView reloadData];
//    self.lblPosition.top = self.lblContent.top+self.lblContent.height+8;
    
    [self.imgHead addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHead:)]];
}
-(void)loadData{
    [super loadData];
    self.dataIndex = 0;
    [self.provider topicReplyCommentsForTrid:self.trid];
    [self.provider requestData];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
    [self.provider topicReplyCommentsForTrid:self.trid];
    [self.provider useCache:!isRefresh];
    [self.provider requestData];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
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
    cell.lblName.text = tp.u_name;
    [cell.imgHead setImageWithURL:[NSURL URLWithString:[YumiNetworkInfo imageSmallURLWithHead:tp.pic]] placeholderImage:[UIImage imageNamed:IMG_HEAD_DEFAULT]];
    
    [cell.lblContent setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    cell.lblContent.width = self.view.width - 101;
    cell.lblContent.height = 21;
    [cell.lblContent setLineBreakMode:NSLineBreakByCharWrapping];
    cell.lblContent.numberOfLines = 0;
    cell.lblContent.text = tp.text;
    [cell.lblContent sizeToFit];
    
    cell.lblTime.text = [NSString stringWithFormat:@"%@发布", [DateUtils timeConvertToShort:tp.time]];
    cell.lblPosition.text = tp.position;
    cell.lblPosition.top = cell.lblContent.top+cell.lblContent.height+5;
    cell.imgPosition.top = cell.lblPosition.top;
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
    double height = 95;
    NSString *content = tp.text;
    static UILabel* rtLableInstance = nil;
    if (!rtLableInstance) {
        TopicReplyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTopicReplyTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kTopicReplyTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        }
        UILabel *contentLabel = cell.lblContent;
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setTextAlignment:NSTextAlignmentLeft];
        [contentLabel setNumberOfLines:0];
        rtLableInstance = contentLabel;
    }
    rtLableInstance.width = self.view.width - 101;
    [rtLableInstance setText:content];
    [rtLableInstance sizeToFit];
    CGFloat sizeFitHeight = rtLableInstance.height;
    sizeFitHeight = fmaxf(21, sizeFitHeight);
    if (sizeFitHeight>21) {
        height+=sizeFitHeight-21;
    }
    return height;
}


@end
