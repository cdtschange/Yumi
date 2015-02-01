//
//  FriendTableViewCell.m
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgHead.layer.cornerRadius = 3;
    self.imgHead.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation NewFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgHead.layer.cornerRadius = 3;
    self.imgHead.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 3;
    self.btn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)click_btn:(id)sender {
    if([self.delegate respondsToSelector:@selector(cell_clickAddForCell:sender:)]){
        [self.delegate cell_clickAddForCell:self sender:sender];
    }
}

-(void)setUser:(User *)user{
    _user = user;
    self.lblName.text = user.u_name;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[user.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.lblInfo.text = user.reason;
    self.btn.backgroundColor = user.state>0?COLOR_Default_Green:RGBCOLOR(210, 211, 214);
    self.btn.enabled = user.state>0;
    [self setNeedsLayout];
}

@end

@implementation NearUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgHead.layer.cornerRadius = 3;
    self.imgHead.layer.masksToBounds = YES;
}

-(void)setUser:(User *)user{
    _user = user;
    self.lblName.text = user.u_name;
    [self.imgHead setImageWithURL:[NSURL URLWithString:[user.pic imageSmall]] placeholderImage:UIIMG_HEAD_DEFAULT];
    self.lblPosition.text = user.school;
    BOOL isFemale = [user.sex isEqualToString:@"0"];
    self.imgGender.image = [UIImage imageNamed:isFemale?@"icon_female":@"icon_male"];
    int i = arc4random() % 2;
    self.lblLevel2.hidden = i>0;
    [self setNeedsLayout];
}

@end
