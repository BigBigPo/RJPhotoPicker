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

#define SysWindow       [[UIApplication sharedApplication].delegate window]
#define SCBounds        [UIScreen mainScreen].bounds.size
#define SCWidth         [UIScreen mainScreen].bounds.size.width
#define SCHeight        [UIScreen mainScreen].bounds.size.height


#define RJWeak(obj)     __weak typeof(obj) weak##obj = obj;
#define RJRGB(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RJImage(name)         [UIImage imageNamed:name]


#define RJCollectionChangeID @"RJCollectionChangeID"            //change collection notification
#define RJMutableCellClickID @"RJMutableCellClickID"            //change mutable choose click notification
#endif /* RJMacro_h */

typedef NS_ENUM(NSUInteger, RJDirection) {
    RJDirectionUp = 1,
    RJDirectionLeft,
    RJDirectionDown,
    RJDirectionRight,
    RJDirectionUnknow
};
