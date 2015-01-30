//
//  ChatTableViewCell.m
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "ChatTableViewCell.h"

@interface ChatBaseTableViewCell()

@property (nonatomic,strong) NSString *selectedContent;
@property (nonatomic,strong) ChatBaseTableViewCell *selectedCell;

@end


@implementation ChatBaseTableViewCell

- (void)initUI {
    // Initialization code
    self.imgHead.layer.cornerRadius = 5;
    self.imgHead.layer.masksToBounds = YES;
    
    [self.viewWord addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
    
    [self.viewWord addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
   
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    if (longTap.state == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
        self.selectedContent=self.lblWord.text;
        self.selectedCell=self;
        
        [self becomeFirstResponder];
        if([self.delegate respondsToSelector:@selector(chatCellLongPress:content:)]){
            [self.delegate chatCellLongPress:self content:self.lblWord.text];
        }
    }
}
-(void)tapPress:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chatCellTapPress:content:)]){
        
        [self.delegate chatCellTapPress:self content:self.lblWord.text];
    }
}
-(void)menuShow:(UIMenuController *)menu
{
}
-(void)menuHide:(UIMenuController *)menu
{
    self.selectedContent = @"";
    self.selectedCell=nil;
    [self resignFirstResponder];
}
@end
@implementation ChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation ChatRightTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
