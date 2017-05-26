//
//  RJCollectionView.h
//  RJPhotoPicker_OC
//
//  Created by Po on 16/8/19.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJCollectionView : UICollectionView

@property (assign, nonatomic) BOOL isTouch;
@property (assign, nonatomic) CGPoint touchPoint;

- (void)setScrollBlock:(void(^)(CGFloat startY, CGFloat moveY, BOOL isEnd))block;
@end
