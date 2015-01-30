//
//  ChatTableViewCell.h
//  Yumi
//
//  Created by Mao on 12/31/14.
//  Copyright (c) 2014 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChatBaseTableViewCell;

@protocol ChatCellDelegate <NSObject>

-(void)chatCellLongPress:(ChatBaseTableViewCell *)cell content:(NSString *)content;
-(void)chatCellTapPress:(ChatBaseTableViewCell *)cell content:(NSString *)content;

@end

@interface ChatBaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIView *viewWord;
@property (nonatomic,assign) id <ChatCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblWord;
@property (weak, nonatomic) IBOutlet UIView *viewWordBottom;
@property (weak, nonatomic) IBOutlet UIImageView *imgCorrect;
@property (weak, nonatomic) IBOutlet UILabel *lblTranslate;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgWord;

@end

@interface ChatTableViewCell : ChatBaseTableViewCell
@end

@interface ChatRightTableViewCell : ChatBaseTableViewCell

@end
