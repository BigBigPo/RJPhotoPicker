//
//  MBProgressHUD+RJHUD.m
//  TingApp
//
//  Created by Apple on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MBProgressHUD+RJHUD.h"
#import "RJMacro.h"
@implementation MBProgressHUD (RJHUD)

#pragma mark - create function
+ (instancetype)createWithView:(UIView *)view {
    if (view == nil) {
        view = SysWindow;
    }
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (MBProgressHUD *)showProgressInView:(UIView *)view {
    MBProgressHUD * hud = [MBProgressHUD createWithView:view];
    hud.mode = MBProgressHUDModeDeterminate;
    [hud setProgress:0];
    return hud;
}

- (void)showProgress:(CGFloat)progress {
    self.mode = MBProgressHUDModeDeterminate;
    [self setProgress:progress];
}

+ (MBProgressHUD *)showWaiting {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    return hud;
}

+ (MBProgressHUD *)showWaitingWithText:(NSString *)text{
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    hud.label.text = text;
    return hud;
}

+ (MBProgressHUD *)showWaitingWithText:(NSString *)text detail:(NSString *)detail{
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    hud.label.text = text;
    hud.detailsLabel.text = detail;
    return hud;
}

+ (MBProgressHUD *)showWaitingWithText:(NSString *)text detail:(NSString *)detail inView:(UIView *)view{
    MBProgressHUD * hud = [MBProgressHUD createWithView:view];
    hud.label.text = text;
    hud.detailsLabel.text = detail;
    return hud;
}

- (void)showText:(NSString *)text Progress:(CGFloat)progress {
    self.mode = MBProgressHUDModeAnnularDeterminate;
    self.label.text = text;
    self.progress = progress;
}

+ (MBProgressHUD *)showInfo:(NSString *)text {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showInfo:text detail:nil];
    return hud;
}

+ (MBProgressHUD *)showInfo:(NSString *)text detail:(NSString *)detail {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showInfo:text detail:detail];
    return hud;
}

+ (MBProgressHUD *)showInfo:(NSString *)text detail:(NSString *)detail inView:(UIView *)view{
    MBProgressHUD * hud = [MBProgressHUD createWithView:view];
    [hud showInfo:text detail:detail];
    return hud;
}

- (void)showInfo:(NSString *)text detail:(NSString *)detail {
    [self showCustomView:text detail:detail image:nil];
}

#pragma mark - success
+ (MBProgressHUD *)showSuccess {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showSuccess:nil detail:nil];
    return hud;
}

+ (MBProgressHUD *)showSuccess:(NSString *)text {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showSuccess:text detail:nil];
    return hud;
}

+ (MBProgressHUD *)showSuccess:(NSString *)text detail:(NSString *)detail {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showSuccess:text detail:detail];
    return hud;
}

+ (MBProgressHUD *)showSuccess:(NSString *)text detail:(NSString *)detail inView:(UIView *)view {
    MBProgressHUD * hud = [MBProgressHUD createWithView:view];
    [hud showSuccess:text detail:detail];
    return hud;
}

- (void)showSuccess {
    [self showSuccess:nil detail:nil];
}

- (void)showSuccess:(NSString *)text {
    [self showSuccess:text detail:nil];
}

- (void)showSuccess:(NSString *)text detail:(NSString *)detail {
    [self showCustomView:text detail:detail image:[UIImage imageNamed:@"MBProgressSuccess"]];
}



#pragma mark - error and info
+ (MBProgressHUD *)showError {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showError:nil detail:nil];
    return hud;
}

+ (MBProgressHUD *)showError:(NSString *)text {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showError:text detail:nil];
    return hud;
}

+ (MBProgressHUD *)showError:(NSString *)text detail:(NSString *)detail {
    MBProgressHUD * hud = [MBProgressHUD createWithView:SysWindow];
    [hud showError:text detail:detail];
    return hud;
}

+ (MBProgressHUD *)showError:(NSString *)text detail:(NSString *)detail inView:(UIView *)view{
    MBProgressHUD * hud = [MBProgressHUD createWithView:view];
    [hud showError:text detail:detail];
    return hud;
}

- (void)showError {
    [self showError:nil detail:nil];
}

- (void)showError:(NSString *)text {
    [self showError:text detail:nil];
}

- (void)showError:(NSString *)text detail:(NSString *)detail {
    [self showCustomView:text detail:detail image:[UIImage imageNamed:@"MBProgressError"]];
}

#pragma mark - show customView

- (void)showCustomView:(NSString *)text detail:(NSString *)detail image:(UIImage *)image {
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    self.label.text = text;
    self.detailsLabel.text = detail;
    self.customView = imageView;
    self.mode = MBProgressHUDModeCustomView;
    [self hideAnimated:YES afterDelay:1];
}

@end
