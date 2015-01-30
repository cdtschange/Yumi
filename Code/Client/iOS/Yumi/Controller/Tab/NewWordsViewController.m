//
//  NewWordsViewController.m
//  Yumi
//
//  Created by Mao on 15/1/25.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "NewWordsViewController.h"
#import "NewWordTableViewCell.h"
#import "CQMFloatingController.h"
#import "NewWordsSettingViewController.h"

static NSString *kNewWordTableViewCellIdentify = @"NewWordTableViewCell";

@interface NewWordsViewController ()<NewWordCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YumiNetworkProvider *translateProvider;

@end

@implementation NewWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(WaterViewType)listType{
    return WaterRefreshTypeNone;
}
-(UIScrollView *)listView{
    return self.tableView;
}
-(void)initUIAndData{
    [super initUIAndData];
    self.title = @"生词本";
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    self.dataIndex = 0;
    NSArray *arr = [NSArray arrayWithArray:[AccountEntity shared].myNewWords];
    NSMutableArray *marr = [NSMutableArray new];
    for (NSString *str in arr) {
        NSDictionary *dict = @{@"words":str};
        [marr addObject:dict];
    }
    [self dataArrayChanged:marr];
    [self.tableView reloadData];
}

-(void)scrollViewPulling:(BOOL)isRefresh{
    [super scrollViewPulling:isRefresh];
}
-(void)initNavigationBar{
    [super initNavigationBar];
    [self setBackLeftButtonOnNavBar];
    self.navigationItem.rightBarButtonItem = [MyNavigationHelper createNavItemWithType:NavItemTypeSetting target:self action:@selector(click_settings:)];
}
-(void)click_settings:(id)sender{
    NewWordsSettingViewController *vc = [UIViewController instanceByName:@"NewWordsSettingViewController"];
    CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    floatingController.presentMode = UIPresentFrameMode;
    [floatingController setFrameSize:CGSizeMake(300, 280)];
    [floatingController.navigationController.navigationBar setHidden:YES];
    [floatingController presentWithContentViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewWordTableViewCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kNewWordTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell.lblWords setTranslatesAutoresizingMaskIntoConstraints:YES];
    [cell.viewBottom setTranslatesAutoresizingMaskIntoConstraints:YES];
    [cell.lblBottom setTranslatesAutoresizingMaskIntoConstraints:YES];
    [cell.imgBubble setTranslatesAutoresizingMaskIntoConstraints:YES];
    double width = self.view.width;
    cell.lblWords.width = width-30;
    cell.lblWords.height = 23;
    [cell.lblWords setLineBreakMode:NSLineBreakByCharWrapping];
    cell.lblWords.numberOfLines = 0;
    cell.lblWords.text = dict[@"words"];
    [cell.lblWords sizeToFit];
    cell.lblWords.height = fmaxf(23, cell.lblWords.height);
    
    cell.viewBottom.height = 0;
    cell.btnTranslate.selected = NO;
    if (dict[@"translate"]&&[dict[@"translate"] length]>0) {
        cell.btnTranslate.selected = YES;
        NSString *translate = dict[@"translate"];
        
        cell.viewBottom.width = width-30;
        cell.lblBottom.width = width-50;
        cell.lblBottom.font = [UIFont systemFontOfSize:14.0];
        [cell.lblBottom setLineBreakMode:NSLineBreakByCharWrapping];
        cell.lblBottom.numberOfLines = 0;
        [cell.lblBottom setText:translate];
        [cell.lblBottom sizeToFit];
        CGFloat sizeFitHeight = cell.lblBottom.height;
        sizeFitHeight = fmaxf(20, sizeFitHeight);
        cell.viewBottom.height = sizeFitHeight+40;
        cell.imgBubble.width = cell.viewBottom.width;
        cell.imgBubble.height = cell.viewBottom.height - 10;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForCellWithIndexPath:indexPath];
}
- (CGFloat)heightForCellWithIndexPath:(NSIndexPath *)indexPath {
    double height = 72;
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *content = dict[@"words"];
    static UILabel* rtLableInstance = nil;
    if (!rtLableInstance) {
        NewWordTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kNewWordTableViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kNewWordTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
        }
        UILabel *contentLabel = cell.lblWords;
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setTextAlignment:NSTextAlignmentLeft];
        [contentLabel setNumberOfLines:0];
        rtLableInstance = contentLabel;
    }
    double width = self.view.width;
    rtLableInstance.width = width-30;
    [rtLableInstance setText:content];
    [rtLableInstance sizeToFit];
    CGFloat sizeFitHeight = rtLableInstance.height;
    sizeFitHeight = fmaxf(23, sizeFitHeight);
    if (sizeFitHeight>23) {
        height+=sizeFitHeight-23;
    }
    
    if (dict[@"translate"]&&[dict[@"translate"] length]>0) {
        NSString *translate = dict[@"translate"];
        static UILabel* rtLableInstance2 = nil;
        if (!rtLableInstance2) {
            NewWordTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kNewWordTableViewCellIdentify];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:kNewWordTableViewCellIdentify owner:self options:nil] objectAtIndex:0];
            }
            UILabel *contentLabel = cell.lblBottom;
            contentLabel.font = [UIFont systemFontOfSize:14.0];
            [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
            contentLabel.numberOfLines = 0;
            rtLableInstance2 = contentLabel;
        }
        content = translate;
        rtLableInstance2.width = width-50;
        [rtLableInstance2 setText:content];
        [rtLableInstance2 sizeToFit];
        CGFloat sizeFitHeight = rtLableInstance2.height;
        sizeFitHeight = fmaxf(20, sizeFitHeight);
        height += sizeFitHeight + 40;
    }
    return height;
}
-(void)click_read:(NewWordTableViewCell *)cell content:(NSString *)content{
    [self showInfoTip:@"群聊功能暂未开放，敬请期待"];
}
-(void)click_translate:(NewWordTableViewCell *)cell content:(NSString *)content{
    if (!cell.btnTranslate.selected) {
        int index = (int)[self.tableView indexPathForCell:cell].row;
        self.dataArray[index] = @{@"words":content};
        [self.tableView reloadData];
    }else{
        if (content&&content.length>0) {
            __weak NewWordsViewController *weakself = self;
            self.translateProvider = [YumiNetworkProvider new];
            [self.translateProvider translateForText:content];
            [self.translateProvider setCompletionBlockWithSuccess:^(id responseObject) {
                TranslateData *data = responseObject;
                if (data.result&&data.result.length>0) {
                    int index = (int)[weakself.tableView indexPathForCell:cell].row;
                    weakself.dataArray[index] = @{@"words":content,@"translate":data.result};
                    [weakself.tableView reloadData];
                }else{
                    [weakself showInfoTip:@"翻译失败"];
                }
            } failure:^(NSError *error) {
                weakself.failureBlock(error);
            }];
            self.translateProvider.statusBlock = self.statusBlock;
            [self.translateProvider requestData];
        }
    }
}
-(void)click_detail:(NewWordTableViewCell *)cell content:(NSString *)content{
    [self showInfoTip:@"群聊功能暂未开放，敬请期待"];
}

@end
