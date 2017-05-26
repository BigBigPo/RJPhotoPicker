//
//  RJTopView.h
//  RJPhotoPicker
//
//  Created by Po on 2016/11/23.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJControl.h"
#import <Photos/Photos.h>

@protocol RJTopViewDelegate;

@interface RJTopView : UIView
@property (weak, nonatomic) IBOutlet UIView * contentView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet RJControl *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *bottomLeftButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (assign, nonatomic) id<RJTopViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
//- (void)setTitleString:(NSString *)title;
- (void)setImageWithPHAsset:(PHAsset *)asset;

- (void)changeTitleImageWithSelected:(BOOL)isSelected;
@end


@protocol RJTopViewDelegate <NSObject>

@optional
- (void)RJTopView:(RJTopView *)topView clickTitle:(UIButton *)sender;
- (void)RJTopView:(RJTopView *)topView clickBackButton:(UIButton *)sender;
- (void)RJTopView:(RJTopView *)topView clickNextButton:(UIButton *)sender;


@end
