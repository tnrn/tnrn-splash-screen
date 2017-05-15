//
//  RNKitSplashScreenManager.h
//  RNKitSplashScreenManager
//
//  Created by SimMan on 2017/5/12.
//  Copyright © 2017年 RNKit.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTRootView.h>
#else
#import "RCTBridgeModule.h"
#import "RCTRootView.h"
#endif

@interface RNKitSplashScreenManager : NSObject <RCTBridgeModule>

@end
