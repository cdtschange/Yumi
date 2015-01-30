//
//  FindTableViewCell.h
//  Yumi
//
//  Created by Mao on 1/6/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeView.h"

@interface FindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) BadgeView *badgeView;

@end
