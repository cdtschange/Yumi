//
//  NewWordTableViewCell.h
//  Yumi
//
//  Created by Mao on 15/1/25.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewWordTableViewCell;

@protocol NewWordCellDelegate <NSObject>

-(void)click_read:(NewWordTableViewCell *)cell content:(NSString *)content;
-(void)click_translate:(NewWordTableViewCell *)cell content:(NSString *)content;
-(void)click_detail:(NewWordTableViewCell *)cell content:(NSString *)content;

@end

@interface NewWordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblWords;
@property (weak, nonatomic) IBOutlet UIButton *btnRead;
@property (weak, nonatomic) IBOutlet UIButton *btnTranslate;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblBottom;
@property (weak, nonatomic) IBOutlet UIImageView *imgBubble;
@property (nonatomic,assign) id <NewWordCellDelegate> delegate;

@end
