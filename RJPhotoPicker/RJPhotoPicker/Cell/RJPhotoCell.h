//
//  RJPhotoCell.h
//  RJPhotoPicker
//
//  Created by Po on 2016/11/22.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface RJPhotoCell : UICollectionViewCell
@property (weak, atomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (strong, nonatomic) PHAsset * asset;

//@property (assign, nonatomic) BOOL canSelected;
@property (assign, nonatomic) BOOL isSelected;

//- (void)cancelRequest;
//- (void)setImageAsset:(PHAsset *)asset size:(CGSize)targetSize;


@end
