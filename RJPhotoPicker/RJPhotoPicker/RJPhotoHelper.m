//
//  RJPhotoHelper.m
//  RJPhotoPicker_OC
//
//  Created by Po on 16/7/25.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJPhotoHelper.h"
#import <Photos/Photos.h>
#import "RJMacro.h"
@implementation RJPhotoHelper
- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedArray = [NSMutableArray array];
        _maxSelectCount = 5;
        _currentAssetCount = 0;
        _currentCollectionCount = -1;
    }
    return self;
}

#pragma mark - setter
- (void)setSelectIndex:(NSIndexPath *)indexPath {
    NSIndexPath * newIndePath = [NSIndexPath indexPathForRow:indexPath.row inSection:_currentCollectionCount];
    if ([_selectedArray indexOfObject:newIndePath] == NSNotFound) {
        [_selectedArray addObject:newIndePath];
    } else {
        [_selectedArray removeObject:newIndePath];
    }
}

- (void)setSelectCollectionCount:(NSInteger)count {
    if (_collectionData.count <= count) {
        return;
    }
    
    CGFloat targetSize = SCWidth / _lineNum;
    
    _currentCollectionCount = count;
    _currentCollectionTitle = [[_collectionData[_currentCollectionCount] allKeys] lastObject];
    NSArray * temp  = [[_collectionData[_currentCollectionCount] allValues] firstObject];
    
    _currentCollectionData = [NSArray arrayWithArray:temp];
    [[NSNotificationCenter defaultCenter] postNotificationName:RJCollectionChangeID object:nil userInfo:@{@"didEnd":@NO}];
    //load image to cache
    PHCachingImageManager * manager = [[PHCachingImageManager alloc] init];
    [manager stopCachingImagesForAllAssets];
    [manager startCachingImagesForAssets:_currentCollectionData
                              targetSize:CGSizeMake(targetSize, targetSize)
                             contentMode:PHImageContentModeAspectFill
                                 options:nil];
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    [options setProgressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//        [weakself requestProgress:progress];
    }];
    _imagesArray = [NSMutableArray array];
    for (PHAsset * asset in _currentCollectionData) {
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(targetSize, targetSize)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [_imagesArray addObject:result];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RJCollectionChangeID object:nil userInfo:@{@"didEnd":@YES}];
}

#pragma mark - getter
- (void)getAllPhotoData {
    NSMutableArray * tempCollectionsArray = [NSMutableArray array];
    //search collection data
    PHFetchResult * sysfetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //get system collection , set higher level
    NSArray * titlesArray = @[@"Camera Roll", @"Screenshots", @"Recently Added", @"All Photos"];
    for (PHAssetCollection * assetCollection in sysfetchResult) {
        NSString * collectionTitle = assetCollection.localizedTitle;
        NSArray* data = [self getAssetWithCollection:assetCollection];
        if (data.count == 0) {
            continue;
        }
        if ([titlesArray indexOfObject:collectionTitle] != NSNotFound) {
            
            if ([collectionTitle isEqualToString:@"Recently Added"]) {
                [tempCollectionsArray insertObject:@{collectionTitle:data} atIndex:0];
            } else {
                [tempCollectionsArray addObject:@{collectionTitle:data}];
                if ([collectionTitle isEqualToString:@"Camera Roll"]) {
                    _currentCollectionTitle = collectionTitle;
                    _currentCollectionData = data;
                }
            }
        }
    }
    
    //get user collection
    PHFetchResult * userfetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (PHAssetCollection * assetCollection in userfetchResult) {
        NSString * collectionTitle = assetCollection.localizedTitle;
        NSArray * assets = [self getAssetWithCollection:assetCollection];
        if (assets.count != 0) {
            [tempCollectionsArray addObject:@{collectionTitle:assets}];
        }
    }
    
    _collectionData = [NSArray arrayWithArray:tempCollectionsArray];
    if (_collectionData.count > 0 && !_currentCollectionTitle) {
        NSDictionary * dic = _collectionData[0];
        _currentCollectionTitle = [[dic allKeys] lastObject];
        _currentCollectionData = [[dic allValues] lastObject];
    }
}

- (NSArray *)getCurrentCollectionSelectedArray {
    NSMutableArray * array = [NSMutableArray array];
    for (NSIndexPath * indexPath in _selectedArray) {
        if (indexPath.section == _currentCollectionCount) {
            [array addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        }
    }
    return array;
}

/**get PHAsset from collection*/
- (NSArray *)getAssetWithCollection:(PHAssetCollection *)collection {
    //set fetchoptions
    PHFetchOptions * options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    //search
    NSMutableArray * assetArray = [NSMutableArray array];
    PHFetchResult * assetFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    
    for (PHAsset * asset in assetFetchResult) {
        [assetArray addObject:asset];
        
    }
    return assetArray;
}


/**check permission*/
- (void)getPhotoPermission:(void(^)(BOOL havePower))resultBlock {
    if (NSClassFromString(@"PHAsset")) {
//        PHAuthorizationStatus state = [PHPhotoLibrary authorizationStatus];
//        if (state == PHAuthorizationStatusAuthorized) {
//            resultBlock(YES);
//        } else if (state == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                resultBlock(status == PHAuthorizationStatusAuthorized);
            }];
//        } else {
//            resultBlock(NO);
//        }
    } else {
        resultBlock(NO);
    }
}

- (PHAsset *)getAssetWithCollectionCount:(NSInteger)count row:(NSInteger)row {
    if (count < _collectionData.count) {
        NSDictionary * dic = _collectionData[count];
        NSArray * data = [[dic allValues] lastObject];
        
        if (row < data.count) {
            PHAsset * asset = data[row];
            if (asset) {
                return asset;
            }
        }
    }
    return nil;
}

- (NSArray *)getAllAssetWithSelectedArray {
    NSMutableArray * array = [NSMutableArray array];
    for (NSIndexPath * indexPath in _selectedArray) {
        PHAsset * asset = [self getAssetWithCollectionCount:indexPath.section row:indexPath.row];
        if (asset) {
            [array addObject:asset];
        }
    }
    return array;
}
@end







