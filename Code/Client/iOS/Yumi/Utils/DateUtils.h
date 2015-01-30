//
//  DateUtils.h
//  Yumi
//
//  Created by Mao on 1/13/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject


+ (DateUtils *)shared;

+(NSString *)timeConvertToShort:(int)time;
@end
