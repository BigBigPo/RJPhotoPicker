//
//  RJControl.h
//  RJPhotoPicker_OC
//
//  Created by Po on 16/7/28.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJMacro.h"
@interface RJControl : UIControl
- (void)setTrackingBlock:(void(^)(BOOL stop, RJDirection direction, CGPoint changeValue))trackingBlock;
@end
