//
//  SplashScreenManager.m
//  RNKitSplashScreen
//
//  Created by SimMan on 2017/5/12.
//  Copyright © 2017年 RNKit.io. All rights reserved.
//

#import "RNKitSplashScreenManager.h"
#import "RNKitSplashScreen.h"

@implementation RNKitSplashScreenManager

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(open) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_bridge reload];
    });
    [[RNKitSplashScreen shareInstance] openSplashScreen];
}

RCT_EXPORT_METHOD(progress:(float)progress) {
    [[RNKitSplashScreen shareInstance] setProgress:progress];
}

RCT_EXPORT_METHOD(tipText:(NSString *)tipText) {
    [[RNKitSplashScreen shareInstance] setTipText:tipText];
}

RCT_EXPORT_METHOD(close:(NSDictionary *)options) {
    int animationType = UIAnimationNone;
    int duration = 0;
    int delay = 0;
    
    if(options != nil) {
        
        NSArray *keys = [options allKeys];
        
        if([keys containsObject:@"animationType"]) {
            animationType = [[options objectForKey:@"animationType"] intValue];
        }
        if([keys containsObject:@"duration"]) {
            duration = [[options objectForKey:@"duration"] intValue];
        }
        if([keys containsObject:@"delay"]) {
            delay = [[options objectForKey:@"delay"] intValue];
        }
    }
    
    [[RNKitSplashScreen shareInstance] closeWithAnimationType:animationType duration:duration delay:delay];
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"animationType": @{
                     @"none": @(UIAnimationNone),
                     @"fade": @(UIAnimationFade),
                     @"scale": @(UIAnimationScale),
                     }
             };
}

@end
