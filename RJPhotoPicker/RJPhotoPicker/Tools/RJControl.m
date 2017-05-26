//
//  RJControl.m
//  RJPhotoPicker_OC
//
//  Created by Po on 16/7/28.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJControl.h"

typedef void(^RJControlTrackingBlock)(BOOL stop, RJDirection direction,CGPoint changeValue);

@interface RJControl ()

@property (copy, nonatomic) RJControlTrackingBlock trackingBlock;

@property (assign, nonatomic) CGPoint lastPoint;                        //记录点
@property (assign, nonatomic) RJDirection currentDirection;             //当前方向
@end


@implementation RJControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:SysWindow];
    _lastPoint = point;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    CGPoint point = [touch locationInView:SysWindow];
    CGPoint value = [self getChangeValue:point];
    [self updateDirectionWithChangeValue:value];
    _trackingBlock(NO,_currentDirection, value);
    _lastPoint = point;
    return YES;
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    CGPoint point = [touch locationInView:SysWindow];
    CGPoint value = [self getChangeValue:point];
    
    _trackingBlock(YES,_currentDirection, value);
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    UITouch * touch = [event.allTouches anyObject];
    CGPoint point = [touch locationInView:SysWindow];
    CGPoint value = [self getChangeValue:point];
    
    _trackingBlock(YES,_currentDirection, value);
}


#pragma mark - function
- (void)updateDirectionWithChangeValue:(CGPoint)point {
    _currentDirection = point.y > 0 ? RJDirectionDown : RJDirectionUp;
}

#pragma mark - setter
- (void)setTrackingBlock:(void(^)(BOOL stop, RJDirection direction, CGPoint changeValue))trackingBlock {
    _trackingBlock = trackingBlock;
}

#pragma mark - getter
- (CGPoint)getChangeValue:(CGPoint)point {
    return CGPointMake(point.x - _lastPoint.x, point.y - _lastPoint.y);
}


@end
