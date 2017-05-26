//
//  RJPhotoPicker.h
//  RJPhotoPicker
//
//  Created by Po on 2016/11/21.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface RJPhotoPicker : UIViewController

- (void)setFinishBlock:(void(^)(NSArray<PHAsset *> * assets))block;

- (void)setLineNumber:(NSInteger)lineNumber;
- (void)setMaxSelectedNum:(NSInteger)maxNum;
@end
