//
//  RJMacro.h
//  RJPhotoPicker
//
//  Created by Po on 2016/11/21.
//  Copyright © 2016年 Po. All rights reserved.
//

#ifndef RJMacro_h
#define RJMacro_h

#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

//iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size): NO)
//iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size): NO)
//iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size): NO)
//iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size): NO)
//iPhoneX +
#define IS_IPHONE_X_More (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max)

//NavigationBar、StatedBar Height value
#define DEVICE_STATEBAR_HEIGHT (IS_IPHONE_X_More ? 40.0 : 20.0)
#define DEVICE_NAV_HEIGHT (IS_IPHONE_X_More ? 88.0 : 64.0)
#define DEVICE_TABBAR_HEIGHT (IS_IPHONE_X_More ? 83.0 : 49.0)

#define SysWindow       [[UIApplication sharedApplication].delegate window]
#define SCBounds        [UIScreen mainScreen].bounds.size
#define SCWidth         [UIScreen mainScreen].bounds.size.width
#define SCHeight        [UIScreen mainScreen].bounds.size.height


#define RJWeak(obj)     __weak typeof(obj) weak##obj = obj;
#define RJRGB(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RJImage(name)         [UIImage imageNamed:name]


#define RJCollectionChangeID @"RJCollectionChangeID"            //change collection notification
#define RJMutableCellClickID @"RJMutableCellClickID"            //change mutable choose click notification


typedef NS_ENUM(NSUInteger, RJDirection) {
    RJDirectionUp = 1,
    RJDirectionLeft,
    RJDirectionDown,
    RJDirectionRight,
    RJDirectionUnknow
};



#endif /* RJMacro_h */
