//
//  DateUtils.m
//  Yumi
//
//  Created by Mao on 1/13/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (DateUtils *)shared{
    static DateUtils *shared_ = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared_ = [[DateUtils alloc] init];
    });
    return shared_;
}
+(NSString *)timeConvertToShort:(int)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *now = [NSDate date];
    if ([[now stringWithFormat:@"yyyy-M-d"] isEqualToString:[date stringWithFormat:@"yyyy-M-d"]]) {
        return [date stringWithFormat:@"HH:mm"];
    }else{
        now = [now dateByAddingDays:-1];
        if ([[now stringWithFormat:@"yyyy-M-d"] isEqualToString:[date stringWithFormat:@"yyyy-M-d"]]) {
            return @"昨天";
        }
    }
    if ([[now stringWithFormat:@"yyyy"] isEqualToString:[date stringWithFormat:@"yyyy"]]) {
        return [date stringWithFormat:@"M/d"];
    }
    return [date stringWithFormat:@"yy/M/d"];
}
@end
