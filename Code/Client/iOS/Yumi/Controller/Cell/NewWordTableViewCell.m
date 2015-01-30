//
//  NewWordTableViewCell.m
//  Yumi
//
//  Created by Mao on 15/1/25.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import "NewWordTableViewCell.h"

@implementation NewWordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)click_read:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if([self.delegate respondsToSelector:@selector(click_read:content:)]){
        
        [self.delegate click_read:self content:self.lblWords.text];
    }
}
- (IBAction)click_translate:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if([self.delegate respondsToSelector:@selector(click_translate:content:)]){
        
        [self.delegate click_translate:self content:self.lblWords.text];
    }
}
- (IBAction)click_detail:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if([self.delegate respondsToSelector:@selector(click_detail:content:)]){
        
        [self.delegate click_detail:self content:self.lblWords.text];
    }
}

@end
