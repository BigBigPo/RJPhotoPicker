//
//  RJPhotoCell.m
//  RJPhotoPicker
//
//  Created by Po on 2016/11/22.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJPhotoCell.h"

#import "RJMacro.h"
#import "MBProgressHUD+RJHUD.h"
#import "PHAsset+RJAsset.h"


@interface RJPhotoCell ()
@property (assign, atomic) PHImageRequestID requestID;
@property (assign, nonatomic) PHContentEditingInputRequestID editRequestID;

@property (strong, nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) CALayer * maskLayer;


@end

@implementation RJPhotoCell


- (void)cancelRequest {
    if (_requestID != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_requestID];
        _requestID = PHInvalidImageRequestID;
    }
}
- (IBAction)pressSelectedButton:(UIButton *)sender {
    //查询图片信息
    if (_editRequestID) {
        [_asset cancelContentEditingInputRequest:_editRequestID];
    }
    
    _editRequestID = [_asset checkIsICloudResource:^(BOOL isCloud) {
        if (!isCloud) {
            [sender setSelected:!sender.selected];
            if (!sender.selected) {
                [sender setTitle:@"" forState:UIControlStateNormal];
            }
            RJWeak(self)
            [[NSNotificationCenter defaultCenter] postNotificationName:RJMutableCellClickID object:weakself userInfo:@{@"selected":@(sender.selected)}];
        } else {
            [MBProgressHUD showInfo:@"iCloud请先下载到本地"];
        }
    }];
    
}

//- (void)setImageAsset:(PHAsset *)asset size:(CGSize)targetSize{
//    _asset = asset;
//    [self cancelRequest];
////    [_imageView setImage:RJImage(@"rj_placeholderImage")];
//    _canSelected = NO;
//    RJWeak(self);
//    PHImageManager * imageManager = [PHImageManager defaultManager];
//    if (_requestID) {
//        [imageManager cancelImageRequest:_requestID];
//        _requestID = PHInvalidImageRequestID;
//    }
//
//    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
//    options.resizeMode = PHImageRequestOptionsResizeModeFast;
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//    options.networkAccessAllowed = YES;
//    options.synchronous = NO;
//    
//    [options setProgressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//        [weakself requestProgress:progress];
//    }];
//    
//    _requestID = [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            if (result) {
//                [weakself.imageView setImage:result];
//            } else {
//                [weakself.imageView setImage:RJImage(@"rj_placeholderImage")];
//            }
//        weakself.requestID = PHInvalidImageRequestID;
//    }];
//
//    //查询图片信息
//    if (_editRequestID) {
//        [asset cancelContentEditingInputRequest:_editRequestID];
//    }
//    PHContentEditingInputRequestOptions * editOptions = [[PHContentEditingInputRequestOptions alloc] init];
//    editOptions.networkAccessAllowed = NO;
//    _editRequestID = [asset requestContentEditingInputWithOptions:editOptions completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
//        weakself.canSelected = ![info[PHContentEditingInputResultIsInCloudKey] boolValue];
//    }];
//}

- (void)requestProgress:(CGFloat)progress {
    if (_hud) {
        [_hud setProgress:progress];
        if (progress >= 1) {
            [_hud hideAnimated:YES];
        }
        return;
    }
    _hud = [MBProgressHUD showProgressInView:self];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        [_imageView.layer addSublayer:[self getMaskLayer]];
    } else if (_maskLayer){
        [_maskLayer removeFromSuperlayer];
        _maskLayer = nil;
    }
}

- (CALayer *)getMaskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        [_maskLayer setFrame:self.bounds];
        [_maskLayer setBackgroundColor:RJRGB(222, 222, 222, 0.5).CGColor];
    }
    return _maskLayer;
}
@end
