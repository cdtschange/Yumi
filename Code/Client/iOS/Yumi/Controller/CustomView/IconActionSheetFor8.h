//
//  AWActionSheet.h
//  AWIconSheet
//
//  Created by Narcissus on 10/26/12.
//  Copyright (c) 2012 Narcissus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIActionSheet+iOS8Compatible.h"
@class IconActionSheetCell;

@protocol IconActionSheetDelegate <UIActionSheetDelegate>

- (int)numberOfItemsInActionSheet;
- (IconActionSheetCell*)cellForActionAtIndex:(NSInteger)index;
- (void)didTapOnItemAtIndex:(NSInteger)index;

@end

@interface IconActionSheetFor8 : UIAlertController
-(id)initWithDelegate:(id<IconActionSheetDelegate>)delegate title:(NSString *)title itemCount:(int)count;
@end


@interface IconActionSheetCellFor8 : UIView
@property (nonatomic,strong)UIImageView* iconView;
@property (nonatomic,strong)UILabel*     titleLabel;
@property (nonatomic,assign)int          index;
@end