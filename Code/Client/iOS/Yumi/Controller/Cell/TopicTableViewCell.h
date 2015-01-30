//
//  Topic2TableViewCell.h
//  Yumi
//
//  Created by Mao on 15/1/18.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface TopicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblVisitCnt;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblCommentCnt;

@end
