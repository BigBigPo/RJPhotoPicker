//
//  RJAlbumCell.h
//  RJPhotoPicker
//
//  Created by Po on 2016/11/24.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rj_imageView;
@property (weak, nonatomic) IBOutlet UILabel *rj_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rj_detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedStateImage;

- (void)setImageAsset:(id)asset;
@end
