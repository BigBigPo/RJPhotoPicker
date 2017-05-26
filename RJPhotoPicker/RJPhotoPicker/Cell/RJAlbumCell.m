//
//  RJAlbumCell.m
//  RJPhotoPicker
//
//  Created by Po on 2016/11/24.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJAlbumCell.h"
#import <Photos/Photos.h>
#import "RJMacro.h"
@interface RJAlbumCell ()

@property (assign, nonatomic) PHImageRequestID requestId;

@end

@implementation RJAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageAsset:(id)asset {
    if(NSClassFromString(@"PHAsset")) {
        [self setPhotoWithPhoto:asset];
    }
}

- (void)setPhotoWithPhoto:(PHAsset *)asset {
    if (_requestId) {
        [[PHImageManager defaultManager] cancelImageRequest:_requestId];
    }
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGFloat width = self.frame.size.width * 2;
    CGFloat height = width / asset.pixelWidth * asset.pixelHeight;
    if (height < self.frame.size.height) {
        height = self.frame.size.height * 2;
        width = height / asset.pixelHeight * asset.pixelWidth;
    }
    if (asset) {
        RJWeak(self)
        _requestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(width, height) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                [weakself.rj_imageView setImage:nil];
                [weakself.rj_imageView setImage:result];
            }
        }];
    } else {
        [self.rj_imageView setImage:RJImage(@"rj_placeholderImage")];
    }
}

@end
