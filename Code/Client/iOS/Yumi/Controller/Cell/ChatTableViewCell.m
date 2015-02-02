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
    
    [self.imgBgWord addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
    
    [self.imgBgWord addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
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

-(void)setChat:(Chat *)chat{
    _chat = chat;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[chat.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    NSString *contentStr = chat.words;
    if ([chat.type isEqualToString:@"voice"]) {
        contentStr = @"语音";
    }
    [self.lblWord setText:contentStr];
    if ([chat.type isEqualToString: @"text-t"]) {
        [self.viewWordBottom setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.lblTranslate.text = chat.translate;
    }else{
        self.viewWordBottom.height = 0;
        [self.viewWordBottom setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    [self setNeedsLayout];
}
+(CGFloat)heightForCellWithChat:(Chat *)chat width:(double)width{
    NSString *content = chat.words;
    if ([chat.type isEqualToString:@"voice"]) {
        content = @"语音";
    }
    CGRect rectToFit = [content boundingRectWithSize:CGSizeMake(width-113, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    double height = rectToFit.size.height;
    height+=50;
    if ([chat.type isEqualToString: @"text-m"]) {
        if (chat.photoImage) {
            height += chat.photoImage.size.height;
            height+=12;
        }
    }else if([chat.type isEqualToString: @"text-t"]){
        rectToFit = [chat.translate boundingRectWithSize:CGSizeMake(width-113, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
        height += rectToFit.size.height;
        height+=12;
    }
    return height;
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
