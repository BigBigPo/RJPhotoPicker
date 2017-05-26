//
//  RJAlbumChooseView.h
//  RJPhotoPicker
//
//  Created by Po on 2016/11/24.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJAlbumChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame albums:(NSArray *)albums clickBlock:(void(^)(NSInteger index))block;

- (void)setCurrentCount:(NSInteger)count;
@end

