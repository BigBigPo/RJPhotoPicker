//
//  RJTopView.m
//  RJPhotoPicker
//
//  Created by Po on 2016/11/23.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJTopView.h"
#import "UIButton+RJButton.h"
#import "MBProgressHUD+RJHUD.h"

@interface RJTopView () <UIScrollViewDelegate>

@property (assign, nonatomic) PHImageRequestID requestID;
@property (strong, nonatomic) MBProgressHUD * hud;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (assign, nonatomic) BOOL isFullImageBtn;
@property (assign, nonatomic) CGSize scaleSize;
@property (assign, nonatomic) CGFloat maxScaleValue;
@property (assign, nonatomic) CGFloat imageLeftMargin;
@property (assign, nonatomic) CGFloat imageTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentViewHeight;

@end

@implementation RJTopView

- (void)dealloc {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"RJTopView" owner:self options:nil];
        [self addSubview:_contentView];
        [_contentView setFrame:self.bounds];
        
        CGAffineTransform transform=CGAffineTransformMakeRotation(0.5 * M_PI);
        _titleImageView.transform = transform;
        
        [_scrollView setDelegate:self];
        _maxScaleValue = 2;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = _maxScaleValue;
        
        _imageLeftMargin = 0;
        _imageTopMargin = 0;
        
        _isFullImageBtn = YES;
    }
    return self;
}

- (void)setImageWithPHAsset:(PHAsset *)asset {
    
    PHImageManager * imageManager = [PHImageManager defaultManager];
    
    if (_requestID) {
        [imageManager cancelImageRequest:_requestID];
        _requestID = 0;
    }
    

    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.networkAccessAllowed = YES;
    RJWeak(self);
    [options setProgressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself requestProgress:progress];
            if (error) {
                NSString * errorString = error.userInfo[@"NSLocalizedDescription"];
                if (errorString) {
                    if (weakself.hud) {
                        [weakself.hud showError:errorString];
                    } else {
                        [MBProgressHUD showError:errorString];
                    }
                }
                [weakself.showImageView setImage:[UIImage imageNamed:@"rj_placeholderImage"]];
            }
        });
    }];
    
    _scaleSize = [self getScaleSizeWithSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) boxSize:_scrollView.frame.size isFullAspect:_isFullImageBtn];
    
        CGSize targetSize = CGSizeMake(_scaleSize.width * _maxScaleValue, _scaleSize.height * _maxScaleValue);
        weakself.requestID = [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
                    [weakself.showImageView setImage:result];
                    [weakself configLayoutWithSize:_scaleSize];
                }
        }];
}

- (void)configLayoutWithSize:(CGSize)size {
    
    CGFloat marginWidth;
    CGFloat marginHeight;
    
    CGSize contentSize = _isFullImageBtn ? CGSizeMake(size.width, size.height):size;
    [_scrollView setZoomScale:1 animated:YES];
    [_scrollView setContentSize:contentSize];
    _imageContentViewWidth.constant = size.width;
    _imageContentViewHeight.constant = size.height;
    
    [_showImageView setFrame:_imageContentView.bounds];
    
    marginWidth = (_scrollView.frame.size.width - size.width) / 2;
    marginHeight = (_scrollView.frame.size.height - size.height) / 2;

    CGPoint scrollContentOffset = CGPointMake(marginWidth < 0 ? -marginWidth : 0,
                                              marginHeight < 0 ? -marginHeight : 0);
    [_scrollView setContentOffset:scrollContentOffset];
    
    _imageTopMargin = marginHeight > 0 ? marginHeight : 0;
    _imageLeftMargin = marginWidth > 0 ? marginWidth : 0;
    _imageContentViewLeft.constant = _imageLeftMargin;
    _imageContentViewTop.constant = _imageTopMargin;
    [self layoutIfNeeded];
    
}

- (IBAction)pressTittleButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self changeTitleImageWithSelected:sender.selected];
    if (_delegate && [_delegate respondsToSelector:@selector(RJTopView:clickTitle:)]) {
        [_delegate RJTopView:self clickTitle:sender];
    }
}

- (IBAction)pressBackButton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(RJTopView:clickBackButton:)]) {
        [_delegate RJTopView:self clickBackButton:sender];
    }
}

- (IBAction)pressNextButton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(RJTopView:clickNextButton:)]) {
        [_delegate RJTopView:self clickNextButton:sender];
    }
}

- (IBAction)pressBottomLeftButton:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    _isFullImageBtn = !sender.selected;
    CGSize size = [self getScaleSizeWithSize:_scaleSize boxSize:_scrollView.frame.size isFullAspect:_isFullImageBtn];
    [self configLayoutWithSize:size];
}

#pragma mark - scrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    CGFloat zoomValue = scrollView.zoomScale;
    
    CGFloat widthValue = (scrollView.frame.size.width - _imageContentView.frame.size.width) / 2;
    CGFloat heightValue = (scrollView.frame.size.height - _imageContentView.frame.size.height) / 2;
    
    _imageContentViewLeft.constant = widthValue > 0 ? widthValue : 0;
    _imageContentViewTop.constant = heightValue > 0 ? heightValue : 0;
}


- (void)changeTitleImageWithSelected:(BOOL)isSelected {
    [_titleButton setSelected:isSelected];
    CGFloat angle = isSelected ? 0.999 : -0.999;
    CGAffineTransform transform = _titleImageView.transform;
    CGAffineTransform newtransform = CGAffineTransformRotate(transform, angle * M_PI);

    RJWeak(self);
    [UIView animateWithDuration:0.2 animations:^{
        [weakself.titleImageView setTransform:newtransform];
        [weakself.backButton setAlpha:1 - isSelected];
        [weakself.nextButton setAlpha:1 - isSelected];
    }];
}

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

- (CGSize)getScaleSizeWithSize:(CGSize)size boxSize:(CGSize)boxSize isFullAspect:(BOOL)isFullAspect {
    CGFloat width = size.width != boxSize.width ? boxSize.width : size.width;
    CGFloat height = width / size.width * size.height;
    
    if ((isFullAspect && height < boxSize.height)
        || (!isFullAspect && height > boxSize.height)) {
        height = boxSize.height;
        width = height / size.height * size.width;
    }
    return CGSizeMake(width, height);
}
@end
