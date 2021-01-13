//
//  ABTime.m
//  Demo
//
//  Created by qp on 2020/5/11.
//  Copyright © 2020 ab. All rights reserved.
//

#import "ABTime.h"

@implementation ABTime
+ (ABTime *)shared {
    static ABTime *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 获取当前时间  eg:2010/10/09 13:51:02
+ (NSString *)time {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

/// 获取当前时间戳(秒)  eg:1587695039
+ (NSString *)timestamp {
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

/// 获取当前时间戳(毫秒)   eg:1587695039000
+ (NSString *)timestampM {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}



// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)timestampToTime:(NSString *)timestamp format:(nullable NSString *)format{
    NSString *timestampStr = timestamp;
    if ([format isKindOfClass:[NSNumber class]]) {
        timestampStr = [NSString stringWithFormat:@"%@", timestamp];
    }
    if (timestampStr.length != 10 && timestampStr.length != 13) {
        return timestampStr;
    }
    
    NSTimeInterval time = [timestampStr doubleValue];
    if (timestampStr.length > 10) {
        time = [timestampStr doubleValue]/1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (format == nil) {
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    }else{
        [dateFormatter setDateFormat:format];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return  currentDateStr;
}

//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)timestampFromYMDHMS:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}



- (NSString *)howMuchTimePassed:(NSString *)timestamp {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval inputTime = [self secondTimestamp:timestamp];
    
    NSTimeInterval cha = currentTime - inputTime;
    
    return [self _timePassed:cha timestamp:timestamp];
}

- (NSString *)_timePassed:(NSTimeInterval)cha timestamp:(NSString *)timestamp {
    //小于60s
    if (cha < 60) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    
    //小于1小时(60*60)
    if (cha < 3600) {
        NSInteger minute = cha/60;
        return [NSString stringWithFormat:@"%ld分钟前", (long)minute];
    }
    
    //小于一天(60*60*24)
    if (cha < 3600*24) {
        NSInteger hours = cha/3600;
        return [NSString stringWithFormat:@"%ld小时前", (long)hours];
    }
    
    
    NSInteger days = cha/3600/24;
    if (days < 2) {
        return @"昨天";
    }
    return [ABTime timestampToTime:timestamp format:nil];
}

//+ (NSString *) compareCurrentTime:(NSString *)str
//{
//
//    //把字符串转为NSdate
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
//    NSDate *timeDate = [dateFormatter dateFromString:str];
//
//    //得到与当前时间差
//    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
//    timeInterval = -timeInterval;
//    //标准时间和北京时间差8个小时
//    timeInterval = timeInterval - 8*60*60;
//    long temp = 0;
//    NSString *result;
//    if (timeInterval < 60) {
//        result = [NSString stringWithFormat:@"刚刚"];
//    }
//    else if((temp = timeInterval/60) <60){
//        result = [NSString stringWithFormat:@"%d分钟前",temp];
//    }
//
//    else if((temp = temp/60) <24){
//        result = [NSString stringWithFormat:@"%d小时前",temp];
//    }
//
//    else if((temp = temp/24) <30){
//        result = [NSString stringWithFormat:@"%d天前",temp];
//    }
//
//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%d月前",temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%d年前",temp];
//    }
//
//    return  result;
//}


///** 通过行数, 返回更新时间 */
//- (NSString *)updateTimeForRow:(NSInteger)row {
//    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
//    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
//    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
//     NSTimeInterval createTime = self.model.tracks.list[row].createdAt/1000;
//    // 时间差
//    NSTimeInterval time = currentTime - createTime;
//
//    // 秒转小时
//    NSInteger hours = time/3600;
//    if (hours<24) {
//        return [NSString stringWithFormat:@"%ld小时前",hours];
//    }
//    //秒转天数
//    NSInteger days = time/3600/24;
//    if (days < 30) {
//        return [NSString stringWithFormat:@"%ld天前",days];
//    }
//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",years];
//}

#pragma mark --public
//时间戳转换为date
- (NSDate *)timestampToDate:(NSString *)timestamp {
    NSTimeInterval time = [self secondTimestamp:timestamp];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return date;
}

//始终获取秒级时间戳，如果是毫秒转换一下
- (NSTimeInterval)secondTimestamp:(NSString *)timestamp {
    if (timestamp.length > 10) {
        return [timestamp doubleValue]/1000;
    }
    
    return [timestamp doubleValue];
}

+ (NSString *)dateToTime:(NSDate *)date format:(nullable NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (format == nil) {
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    }else{
        [dateFormatter setDateFormat:format];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

@end
