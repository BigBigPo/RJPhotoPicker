//
//  PHAsset+RJAsset.m
//  RJPhotoPicker
//
//  Created by Po on 2017/4/17.
//  Copyright © 2017年 Po. All rights reserved.
//

#import "PHAsset+RJAsset.h"

@implementation PHAsset (RJAsset)

- (PHContentEditingInputRequestID)checkAssetInfo:(void(^)(NSDictionary * info))infoBlock {
    PHContentEditingInputRequestOptions * editOptions = [[PHContentEditingInputRequestOptions alloc] init];
    editOptions.networkAccessAllowed = NO;
    PHContentEditingInputRequestID editID = [self requestContentEditingInputWithOptions:editOptions completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        if (infoBlock) {
            infoBlock(info);
        }
    }];
    
    return editID;
}

- (PHContentEditingInputRequestID)checkIsICloudResource:(void(^)(BOOL isCloud))block {
    PHContentEditingInputRequestID editID = [self checkAssetInfo:^(NSDictionary *info) {
        BOOL isCloud = [info[PHContentEditingInputResultIsInCloudKey] boolValue];
        block(isCloud);
    }];
    return editID;
}
@end
