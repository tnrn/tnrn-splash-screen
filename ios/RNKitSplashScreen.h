//
//  RNKitSplashScreen.h
//  RNKitSplashScreen
//
//  Created by SimMan on 2017/5/8.
//  Copyright © 2017年 RNKit.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTRootView.h>
#else
#import "RCTRootView.h"
#endif

typedef NS_ENUM(NSInteger, RCTCameraAspect) {
    UIAnimationNone = 0,
    UIAnimationFade = 1,
    UIAnimationScale = 2
};

@interface RNKitSplashScreen : NSObject

@property (nonatomic, assign) float progress;
@property (nonatomic, copy) NSString *tipText;
@property (nonatomic, strong) UIImage *splashImage;
@property (nonatomic, strong) UIImage *progressImage;

+ (instancetype)shareInstance;
- (void) openSplashScreen:(RCTRootView *)rv;
- (void) openSplashScreen;
- (void) closeWithAnimationType:(RCTCameraAspect)animationType
                       duration:(int)duration
                          delay:(int)delay;

@end
