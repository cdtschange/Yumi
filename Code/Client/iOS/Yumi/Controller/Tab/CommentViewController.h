//
//  CommentTopicReplyViewController.h
//  Yumi
//
//  Created by Mao on 1/9/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^CommentCompleteBlock)(BOOL select, NSString* content);

@interface CommentViewController : BaseViewController

@property (copy, nonatomic) CommentCompleteBlock block;
@end
