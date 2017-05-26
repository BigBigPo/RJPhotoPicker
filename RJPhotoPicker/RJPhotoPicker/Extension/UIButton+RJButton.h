//
//  UIButton+RJButton.h
//  tools
//
//  Created by Po on 2016/11/15.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RJButton)

/**
 上下居中(图片在上)
 */
-(void)rj_topIconBottomText;
-(void)rj_topIconBottomTextWithSpacing:(CGFloat)spacing;

/**
 水平居中(图片在右)
 */
- (void)rj_leftTextRightImage;
- (void)rj_leftTextRightimageWithSpacing:(CGFloat)spacing;

@end
