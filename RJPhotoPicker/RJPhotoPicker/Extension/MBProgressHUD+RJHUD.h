

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (RJHUD)

/**
 *  @brief 自定义视图
 *  @param text   标题
 *  @param detail 详情
 *  @param image  icon
 */
- (void)showCustomView:(NSString *)text detail:(NSString *)detail image:(UIImage *)image;


/**
 *  @brief 等待视图（菊花）
 */
+ (MBProgressHUD *)showWaiting;
+ (MBProgressHUD *)showWaitingWithText:(NSString *)text;
+ (MBProgressHUD *)showWaitingWithText:(NSString *)text inView:(UIView *)view;

/**
 *  @brief 显示进度条
 *  @param text 文字
 *  @param progress 进度
 */
//圆环
- (void)showText:(NSString *)text Progress:(CGFloat)progress;
//扇形
+ (MBProgressHUD *)showProgressInView:(UIView *)view;
- (void)showProgress:(CGFloat)progress;

/**
 *  @brief 显示信息
 */
+ (MBProgressHUD *)showInfo:(NSString *)text;
+ (MBProgressHUD *)showInfo:(NSString *)text detail:(NSString *)detail;
+ (MBProgressHUD *)showInfo:(NSString *)text detail:(NSString *)detail inView:(UIView *)view;
- (void)showInfo:(NSString *)text detail:(NSString *)detail;

/**
 *  @brief 显示成功
 */
+ (MBProgressHUD *)showSuccess;
+ (MBProgressHUD *)showSuccess:(NSString *)text;
+ (MBProgressHUD *)showSuccess:(NSString *)text detail:(NSString *)detail;
+ (MBProgressHUD *)showSuccess:(NSString *)text detail:(NSString *)detail inView:(UIView *)view;
- (void)showSuccess;
- (void)showSuccess:(NSString *)text;
- (void)showSuccess:(NSString *)text detail:(NSString *)detail;

/**
 *  @brief 显示失败
 */
+ (MBProgressHUD *)showError;
+ (MBProgressHUD *)showError:(NSString *)text;
+ (MBProgressHUD *)showError:(NSString *)text detail:(NSString *)detail;
+ (MBProgressHUD *)showError:(NSString *)text detail:(NSString *)detail inView:(UIView *)inView;
- (void)showError;
- (void)showError:(NSString *)text;
- (void)showError:(NSString *)text detail:(NSString *)detail;






@end
