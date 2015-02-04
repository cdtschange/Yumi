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
    [self.viewWordBottom setTranslatesAutoresizingMaskIntoConstraints:YES];
    if ([self isKindOfClass:[ChatRightTableViewCell class]]) {
        self.imgBgWord.image = [UIImage imageNamed:@"chatBubble_Sending_Solid"];
    }
    self.lblTranslate.text = @"";
    if ([chat.type isEqualToString: @"text-t"]) {
        CGRect rectToFit = [contentStr boundingRectWithSize:CGSizeMake(self.width-113, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
        CGRect rectToFit2 = [chat.translate boundingRectWithSize:CGSizeMake(self.width-100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
        double height = rectToFit.size.height;
        double height2 = rectToFit2.size.height;
        self.viewWordBottom.top = height+33;
        self.viewWordBottom.height = height2+23;
        self.lblTranslate.text = chat.translate;
        self.viewWordBottomBg.backgroundColor = RGBCOLOR(32, 47, 70);
        self.viewWordBottomBg.layer.borderWidth = 0;
        self.viewWordBottomBg.layer.cornerRadius = 3;
        self.viewWordBottomBg.layer.masksToBounds = YES;
    }else if ([chat.type isEqualToString: @"text-m"]) {
        if ([self isKindOfClass:[ChatRightTableViewCell class]]) {
            self.imgBgWord.image = [UIImage imageNamed:@"chatBubble_Sending_gray"];
        }
        [self.imgCorrect setTranslatesAutoresizingMaskIntoConstraints:YES];
        if (!chat.photoImage) {
            self.viewWordBottom.height = 0;
        }else{
            CGRect rectToFit = [contentStr boundingRectWithSize:CGSizeMake(self.width-113, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
            self.imgCorrect.image = chat.photoImage;
            self.imgCorrect.size = chat.photoImage.size;
            self.imgCorrect.left = self.viewWordBottom.width - self.imgCorrect.width - 3;
            double height = rectToFit.size.height;
            double height2 = chat.photoImage.size.height;
            self.viewWordBottom.top = height+33;
            self.viewWordBottom.height = height2+23;
            self.lblTranslate.text = chat.translate;
//            self.viewWordBottom.backgroundColor = COLOR_Default_LightGreen;
            self.imgCorrect.layer.cornerRadius = 3;
            self.imgCorrect.layer.borderColor = RGBCOLOR(103, 131, 217).CGColor;
            self.imgCorrect.layer.borderWidth = 0.5;
            self.imgCorrect.layer.masksToBounds = YES;
        }
    }else{
        self.viewWordBottom.height = 0;
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
        rectToFit = [chat.translate boundingRectWithSize:CGSizeMake(width-100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
        height += rectToFit.size.height;
        height+=20;
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
