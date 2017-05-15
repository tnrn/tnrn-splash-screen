//
//  RNKitEXOCR.m
//  RNKitEXOCR
//
//  Created by SimMan on 2017/5/8.
//  Copyright © 2017年 RNKit.io. All rights reserved.
//

#import "RNKitSplashScreen.h"

#if __has_include(<React/RCTBridge.h>)

#else

#endif

static RCTRootView *rootView = nil;

#define SELF_CENTER CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)
#define SELF_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SELF_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define TIP_TEXT_HEIGHT 25
#define TIP_TEXT_Y SELF_CENTER.y + 170

#define PROGRESS_X (SELF_WIDTH - 225) / 2
#define PROGRESS_Y TIP_TEXT_Y + 30
#define PROGRESS_WIDTH 225
#define PROGRESS_HEIGHT 1

@interface RNKitSplashScreen()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *tipTextLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@end

static CGFloat edgeSizeWithRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

@implementation RNKitSplashScreen

+ (instancetype)shareInstance {
    static RNKitSplashScreen *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RNKitSplashScreen alloc] init];
    });
    
    return _sharedClient;
}

- (void)openSplashScreen:(RCTRootView *)rv
{
    rootView = rv;
    
    UIView *loadView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadView.backgroundColor = [UIColor redColor];
    
    [loadView addSubview:self.bgImageView];
    [loadView addSubview:self.tipTextLabel];
    [loadView addSubview:self.progressView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:rootView  name:RCTContentDidAppearNotification object:rootView];
    
    [rootView setLoadingView:loadView];
}

- (void) openSplashScreen
{
    if (!rootView) {
        return;
    }
    [self openSplashScreen:rootView];
}

- (void)setProgress:(int)progress
{
    if (self.progressView.isHidden) {
        self.progressView.hidden = NO;
    }
    [self.progressView setProgress:progress animated:YES];
}

- (void)setTipText:(NSString *)tipText
{
    [self.tipTextLabel setText:tipText];
}

- (void) closeWithAnimationType:(RCTCameraAspect)animationType duration:(int)duration delay:(int)delay
{
    if (!rootView) {
        return;
    }
    
    if(animationType == UIAnimationNone) {
        rootView.loadingViewFadeDelay = 0;
        rootView.loadingViewFadeDuration = 0;
    }
    else {
        rootView.loadingViewFadeDelay = delay / 1000.0;
        rootView.loadingViewFadeDuration = duration / 1000.0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rootView.loadingViewFadeDelay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [self.tipTextLabel removeFromSuperview];
                       [self.progressView removeFromSuperview];
                       [UIView animateWithDuration:rootView.loadingViewFadeDuration
                                        animations:^{
                                            if(animationType == UIAnimationScale) {
                                                rootView.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                                rootView.loadingView.alpha = 0;
                                            }
                                            else {
                                                rootView.loadingView.alpha = 0;
                                            }
                                        } completion:^(__unused BOOL finished) {
                                            self.progressView = nil;
                                            self.tipTextLabel = nil;
                                            [rootView.loadingView removeFromSuperview];
                                        }];
                   });
    
}

- (UILabel *)tipTextLabel
{
    if (!_tipTextLabel) {
        _tipTextLabel = [[UILabel alloc] init];
        [_tipTextLabel setFrame:CGRectMake(0, TIP_TEXT_Y, SELF_WIDTH, TIP_TEXT_HEIGHT)];
        [_tipTextLabel setTextColor:[UIColor grayColor]];
        [_tipTextLabel setFont:[UIFont systemFontOfSize:12]];
        [_tipTextLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _tipTextLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setFrame:CGRectMake(PROGRESS_X, PROGRESS_Y, PROGRESS_WIDTH, PROGRESS_HEIGHT)];
        _progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
        if (_progressImage) {
            _progressView.progressImage = _progressImage;
        } else {
            _progressView.progressImage = [UIImage imageNamed:@"progress.png"];
        }
        
        UIImage *trackImage = [self imageWithColor:[UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.000] cornerRadius:PROGRESS_HEIGHT/2.0];
        [_progressView setTrackImage:trackImage];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if (_splashImage) {
            _bgImageView.image = _splashImage;
        } else {
            _bgImageView.image = [UIImage imageNamed:@"splash.png"];
        }
    }
    return _bgImageView;
}

- (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = edgeSizeWithRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

@end
