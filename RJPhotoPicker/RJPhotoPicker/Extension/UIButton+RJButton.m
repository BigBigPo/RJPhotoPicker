//
//  UIButton+RJButton.m
//  tools
//
//  Created by Po on 2016/11/15.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "UIButton+RJButton.h"

@implementation UIButton (RJButton)
-(void)rj_topIconBottomText {
    [self rj_topIconBottomTextWithSpacing:3.0];
}

-(void)rj_topIconBottomTextWithSpacing:(CGFloat)spacing {
    CGSize size = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                            -size.width,
                                            -(size.height + spacing),
                                            0.0);
    size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font }];
    self.imageEdgeInsets = UIEdgeInsetsMake(-(size.height + spacing),
                                            0.0,
                                            0.0,
                                            -size.width);
}

- (void)rj_leftTextRightImage {
    [self rj_leftTextRightimageWithSpacing:3.0];
}

- (void)rj_leftTextRightimageWithSpacing:(CGFloat)spacing {
    CGSize size = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -size.width, 0, size.width);
    size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(0, size.width + spacing, 0, -size.width - spacing);
}
@end
