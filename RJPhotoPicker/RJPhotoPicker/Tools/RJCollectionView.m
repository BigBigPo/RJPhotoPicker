//
//  RJCollectionView.m
//  RJPhotoPicker_OC
//
//  Created by Po on 16/8/19.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJCollectionView.h"

typedef void(^ScrollToTopMoreBlock)(CGFloat startY, CGFloat moveY, BOOL isEnd);

@interface RJCollectionView () <UIGestureRecognizerDelegate>
@property (copy, nonatomic) ScrollToTopMoreBlock moveBlock;
@end

@implementation RJCollectionView
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    UITouch * touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    _isTouch = YES;
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    _isTouch = YES;
    _touchPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    _isTouch = YES;
    CGPoint movePoint = [touch locationInView:self];
    if (_moveBlock) {
            _moveBlock(_touchPoint.y, movePoint.y - _touchPoint.y, NO);
        }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self endScrollTopEventWithTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self endScrollTopEventWithTouch:[touches anyObject]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        gestureRecognizer.cancelsTouchesInView = NO;
    }
    return YES;
}

- (void)setScrollBlock:(void(^)(CGFloat startY, CGFloat moveY, BOOL isEnd))block {
    _moveBlock = block;
}

- (void)endScrollTopEventWithTouch:(UITouch *)touch {
    if (_moveBlock) {
        _isTouch = YES;
        CGPoint movePoint = [touch locationInView:self];
        _moveBlock(_touchPoint.y, movePoint.y - _touchPoint.y, YES);
    }
}
@end
