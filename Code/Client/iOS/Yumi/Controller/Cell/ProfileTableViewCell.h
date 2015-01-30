//
//  ProfileTableViewCell.h
//  Yumi
//
//  Created by Mao on 15/1/18.
//  Copyright (c) 2015年 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

@end

@interface ProfileTableViewCell2 : UITableViewCell

@end

@interface ProfileHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@end