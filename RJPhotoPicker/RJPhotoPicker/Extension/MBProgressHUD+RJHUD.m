

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
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = RJRGB(0, 0, 0, 0.4);
    [view addSubview:hud];
    [hud showAnimated:YES];
    hud.minSize = CGSizeMake(100, 40);
    return hud;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (MBProgressHUD *)showWaiting {
    return [self showWaitingWithText:nil inView:SysWindow];
}

+ (MBProgressHUD *)showWaitingWithText:(NSString *)text{
    return [self showWaitingWithText:text inView:SysWindow];
}

+ (MBProgressHUD *)showWaitingWithText:(NSString *)text inView:(UIView *)view {
    MBProgressHUD * hud = [MBProgressHUD createWithView:view];
    hud.label.text = text;
    return hud;
}

- (void)showText:(NSString *)text Progress:(CGFloat)progress {
    self.mode = MBProgressHUDModeAnnularDeterminate;
    self.label.text = text;
    self.progress = progress;
}

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

+ (MBProgressHUD *)showInfo:(NSString *)text {
    return [self showInfo:text detail:nil inView:SysWindow];
}

+ (MBProgressHUD *)showInfo:(NSString *)text detail:(NSString *)detail {
    return [self showInfo:text detail:detail inView:SysWindow];
}

+ (MBProgressHUD *)showInfo:(NSString *)text detail:(NSString *)detail inView:(UIView *)view {
    MBProgressHUD * hud = [MBProgressHUD createWithView:view];
    [hud showInfo:text detail:detail];
    return hud;
}

- (void)showInfo:(NSString *)text detail:(NSString *)detail {
    [self showCustomView:text detail:detail image:nil];
}

#pragma mark - success
+ (MBProgressHUD *)showSuccess {
    return [self showSuccess:nil detail:nil inView:SysWindow];
}

+ (MBProgressHUD *)showSuccess:(NSString *)text {
    return [self showSuccess:text detail:nil inView:SysWindow];
}

+ (MBProgressHUD *)showSuccess:(NSString *)text detail:(NSString *)detail {
    return [self showSuccess:text detail:detail inView:SysWindow];
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
    return [self showError:nil detail:nil inView:SysWindow];
}

+ (MBProgressHUD *)showError:(NSString *)text {
    return [self showError:text detail:nil inView:SysWindow];
}

+ (MBProgressHUD *)showError:(NSString *)text detail:(NSString *)detail {
    return [self showError:text detail:detail inView:SysWindow];
}

+ (MBProgressHUD *)showError:(NSString *)text detail:(NSString *)detail inView:(UIView *)inView {
    MBProgressHUD * hud = [MBProgressHUD createWithView:inView];
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
