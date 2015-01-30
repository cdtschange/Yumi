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

@end

@implementation NearUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgHead.layer.cornerRadius = 3;
    self.imgHead.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)click_btn:(id)sender {
}

@end
