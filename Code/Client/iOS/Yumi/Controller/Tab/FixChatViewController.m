//
//  FixChatViewController.m
//  Yumi
//
//  Created by Mao on 1/16/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "FixChatViewController.h"
#import "RTLabel.h"

@interface FixChatViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgNew;
@property (weak, nonatomic) IBOutlet RichTextEditor *txvNew;
@property (weak, nonatomic) IBOutlet UIImageView *imgFake;

@end

@implementation FixChatViewController

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
    self.title = @"纠错修改语句";
    self.imgNew.hidden = YES;
    self.txvNew.layer.cornerRadius = 3;
    self.txvNew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txvNew.layer.borderWidth = 0.5;
    self.txvNew.layer.masksToBounds = YES;
    [self loadData];
}
-(void)loadData{
    [super loadData];
    self.txvNew.text = self.content;
    [self.txvNew becomeFirstResponder];
}

-(void)initNavigationBar{
    [super initNavigationBar];
    self.navigationItem.leftBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeCancel target:self action:@selector(click_Cancel:)];
    self.navigationItem.rightBarButtonItem=[MyNavigationHelper createNavItemWithType:NavItemTypeSend target:self action:@selector(click_OK:)];
}


- (void)click_OK:(id)sender {
    [self.txvNew resignFirstResponder];
    UIImage *image = [self.txvNew screenshot];
    [self.txvNew setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.imgNew setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.imgFake.image = image;
    self.imgFake.hidden = NO;
    self.txvNew.width = 195;
    self.txvNew.layer.borderWidth = 0;
    self.txvNew.layer.cornerRadius = 0;
    self.txvNew.layer.borderColor = [UIColor clearColor].CGColor;
    [self.txvNew sizeToFit];
    self.txvNew.backgroundColor = COLOR_Default_LightGreen;
    image = [self.txvNew screenshot];
    self.imgNew.width = self.txvNew.width;
    self.imgNew.height = self.txvNew.height;
    self.imgNew.image = image;
    [self routeBack];
    if (self.block) {
        self.block(YES,self.imgNew.image);
        self.block = nil;
    }
}
- (void)click_Cancel:(id)sender {
    [self.txvNew resignFirstResponder];
    [self routeBack];
    if (self.block) {
        self.block(NO,nil);
        self.block = nil;
    }
}

- (RichTextEditorFeature)featuresEnabledForRichTextEditor:(RichTextEditor *)richTextEditor
{
    return RichTextEditorFeatureBold|RichTextEditorFeatureItalic|RichTextEditorFeatureUnderline|RichTextEditorFeatureStrikeThrough|RichTextEditorFeatureTextBackgroundColor|RichTextEditorFeatureTextForegroundColor;
}

@end
