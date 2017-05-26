//
//  PHAsset+RJAsset.h
//  RJPhotoPicker
//
//  Created by Po on 2017/4/17.
//  Copyright © 2017年 Po. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (RJAsset)
- (PHContentEditingInputRequestID)checkAssetInfo:(void(^)(NSDictionary * info))infoBlock;

- (PHContentEditingInputRequestID)checkIsICloudResource:(void(^)(BOOL isCloud))block;
@end
