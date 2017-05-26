//
//  ViewController.m
//  RJPhotoPicker
//
//  Created by Po on 2016/11/21.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "ViewController.h"
#import "RJPhotoPicker.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - event
- (void)reloadImageViewWithAssets:(NSArray<PHAsset *> *)assets {
    for (UIView * view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 0;
    for (PHAsset * asset in assets) {
        CGFloat width = 200.0 / asset.pixelHeight * asset.pixelWidth;
        CGSize targetSize = CGSizeMake(width, 200);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, 200)];
        imageView.contentMode = UIViewContentModeScaleToFill;        [_scrollView addSubview:imageView];
        x += (width + 10);
        
        PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.networkAccessAllowed = YES;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [imageView setImage:result];
        }];
    }
    
    [_scrollView setContentSize:CGSizeMake(x, 200)];
}


- (IBAction)pressSingleChooseButton:(UIButton *)sender {
    [self showPickerWithSelectedNum:1];
}

- (IBAction)pressMutalbeChooseButton:(UIButton *)sender {
    [self showPickerWithSelectedNum:5];
}

#pragma mark - function
- (void)showPickerWithSelectedNum:(NSInteger)count {
    RJPhotoPicker * picker = [[RJPhotoPicker alloc] init];
    [picker setLineNumber:4];
    [picker setMaxSelectedNum:count];
    __weak typeof(self) weakSelf = self;
    [picker setFinishBlock:^(NSArray *assets) {
        [weakSelf reloadImageViewWithAssets:assets];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}
@end
