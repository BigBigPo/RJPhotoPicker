//
//  RJPhotoPicker.m
//  RJPhotoPicker
//
//  Created by Po on 2016/11/21.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJPhotoPicker.h"
#import "RJTopView.h"

#import "RJAlbumChooseView.h"
#import "RJPhotoCell.h"

#import "RJPhotoHelper.h"
#import "RJMacro.h"
#import "MBProgressHUD+RJHUD.h"
#import "RJCollectionView.h"

#import "PHAsset+RJAsset.h"
typedef void(^FinishBlock)(NSArray<PHAsset*> * assets);

static NSString * const RJPhotoPickerCellID = @"RJPhotoPickerCellID";

@interface RJPhotoPicker () <UICollectionViewDelegate, UICollectionViewDataSource, RJTopViewDelegate>

@property (weak, nonatomic) IBOutlet RJCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet RJTopView *navView;
@property (strong, nonatomic) RJAlbumChooseView * albumView;


@property (strong, nonatomic) RJPhotoHelper * helper;

@property (assign, nonatomic) CGFloat topViewTopMax;
@property (assign, nonatomic) CGFloat topViewHeightMax;

@property (assign, nonatomic) CGFloat dragStartY;
@property (assign, nonatomic) BOOL canDragLink;
@property (assign, nonatomic) RJDirection dragDirection;
@property (assign, nonatomic) BOOL canShowImage;
@property (assign, nonatomic) NSIndexPath * currentSelectedIndexPath;
@property (strong, nonatomic) dispatch_queue_t imageReuqestQueue;
@property (assign, nonatomic) CGSize targetSize;

@property (copy, nonatomic) FinishBlock finishBlock;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewWidth;

//@property (strong, nonatomic) NSOperationQueue * imageLoadQueue;
@end

@implementation RJPhotoPicker
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RJCollectionChangeID object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RJMutableCellClickID object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告!!!!!!!!!!!!!!!!!!!!!");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInterface];
    [self doRequest];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - user-define initialization
- (void)doRequest {
    RJWeak(self)
    MBProgressHUD * hud =[MBProgressHUD showWaitingWithText:@"loading"];
    [_helper getPhotoPermission:^(BOOL havePower) {
        if (havePower) {
            [weakself.helper getAllPhotoData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself configNav];
                [weakself configCollectionView];
                [weakself changeAlbumWithCount:0];
                
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showInfo:@"Don't have Permission" detail:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                });
            });
        }
    }];
}

- (void)initData {
    _helper = [[RJPhotoHelper alloc] init];
    _topViewTopMax = 50;
    _topViewHeightMax = SCHeight / 2;
    
    _dragStartY = 0;
    _canDragLink = NO;
    _helper.lineNum = 4;
    _canShowImage = YES;
    _currentSelectedIndexPath = nil;
    _dragDirection = RJDirectionUnknow;
    CGFloat size = [UIScreen mainScreen].bounds.size.width / _helper.lineNum;
    _targetSize = CGSizeMake(size, size);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionDataDidChange:) name:RJCollectionChangeID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mutableClickCell:) name:RJMutableCellClickID object:nil];
    
}

- (void)initInterface {
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - event

#pragma mark - function
- (void)checkTouchEndPosition:(RJDirection)direction {

    RJWeak(self)
    [UIView animateWithDuration:0.15 animations:^{
        CGFloat newTop;
        CGFloat top = weakself.collectionView.contentInset.top;
        if (direction == RJDirectionUp) {
            if (weakself.topViewHeightMax - top > weakself.topViewTopMax) {
                newTop = weakself.topViewTopMax;
            } else {
                newTop = weakself.topViewHeightMax;
            }
        } else {
            if ( (top - weakself.topViewTopMax) > weakself.topViewTopMax) {
                newTop = weakself.topViewHeightMax;
            } else {
                newTop = weakself.topViewTopMax;
            }
        }
        [weakself.collectionView setContentInset:UIEdgeInsetsMake(newTop, 0, 0, 0)];
        [weakself.navViewTop setConstant:- (weakself.topViewHeightMax - newTop)];
        [weakself.view layoutIfNeeded];
    }];
}

- (void)changeAlbumWithCount:(NSInteger)count {
    if (_helper.currentCollectionCount == count) {
        return;
    }
    _currentSelectedIndexPath = nil;
    [_helper setSelectCollectionCount:count];
}

- (void)setAlbumChooseViewShow:(BOOL)isShow {
    CGFloat y = 0;
    if (isShow) {
        [self.view addSubview:[self getAlbumView]];
        y = DEVICE_NAV_HEIGHT;
    } else {
        y = SCHeight;
    }
    
    RJWeak(self)
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = weakself.albumView.frame;
        frame.origin.y = y;
        [weakself.albumView setFrame:frame];
    } completion:^(BOOL finished) {
        if (finished && !isShow) {
            [weakself.albumView removeFromSuperview];
            weakself.albumView = nil;
        }
    }];
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentSelectedIndexPath && [_currentSelectedIndexPath compare:indexPath] == NSOrderedSame) {
        return;
    }
    
    PHAsset * asset = _helper.currentCollectionData[indexPath.row];
    [_navView setImageWithPHAsset:asset];
    
    NSMutableArray * counts = [NSMutableArray arrayWithArray:@[indexPath]];
    if (_currentSelectedIndexPath) {
        [counts addObject:_currentSelectedIndexPath];
    }
    _currentSelectedIndexPath = indexPath;
    [_collectionView reloadItemsAtIndexPaths:counts];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _helper.currentCollectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RJPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:RJPhotoPickerCellID forIndexPath:indexPath];
    [cell.imageView setImage:RJImage(@"rj_placeholderImage")];
    [cell.selectedButton setHidden:(_helper.maxSelectCount == 1)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak RJPhotoCell * myCell = (RJPhotoCell *)cell;
    [myCell.imageView setImage:_helper.imagesArray[indexPath.row]];
    myCell.asset = _helper.currentCollectionData[indexPath.row];
    [myCell setIsSelected:[_currentSelectedIndexPath isEqual:indexPath]];
    if (_helper.maxSelectCount > 1) {
        NSArray * temp = [_helper getCurrentCollectionSelectedArray];
        for (NSIndexPath * tempIndexPath in temp) {
            if ([indexPath compare:tempIndexPath] == NSOrderedSame) {
                NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_helper.currentCollectionCount];
                NSInteger count = [_helper.selectedArray indexOfObject:newIndexPath];
                NSString * title = [NSString stringWithFormat:@"%ld",count + 1];
                [myCell.selectedButton setTitle:title forState:UIControlStateNormal];
                [myCell.selectedButton setSelected:YES];
                return;
            }
        }
    }
    
    [myCell.selectedButton setTitle:@"" forState:UIControlStateNormal];
    [myCell.selectedButton setSelected:NO];
}

#pragma mark - topViewDelegate
- (void)RJTopView:(RJTopView *)topView clickTitle:(UIButton *)sender {
    [self setAlbumChooseViewShow:sender.selected];
}

- (void)RJTopView:(RJTopView *)topView clickBackButton:(UIButton *)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)RJTopView:(RJTopView *)topView clickNextButton:(UIButton *)sender {
    if (_finishBlock) {
        if (_helper.maxSelectCount == 1) {
            if (_currentSelectedIndexPath) {
                PHAsset * asset = [_helper getAssetWithCollectionCount:_helper.currentCollectionCount row:_currentSelectedIndexPath.row];
                [asset checkIsICloudResource:^(BOOL isCloud) {
                    if (isCloud) {
                        [MBProgressHUD showInfo:@"Please Donwload iCloud Image"];
                    } else {
                        [_helper setSelectIndex:_currentSelectedIndexPath];
                        NSArray * datas = [_helper getAllAssetWithSelectedArray];
                        if (datas.count == 0) {
                            [MBProgressHUD showInfo:@"Please choose Image"];
                        }
                        _finishBlock(datas);
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                return;
            }
            [MBProgressHUD showInfo:@"Please choose Image"];
        } else {
            
            NSArray * datas = [_helper getAllAssetWithSelectedArray];
            if (datas.count == 0) {
                [MBProgressHUD showInfo:@"Please choose Image"];
            }
            _finishBlock(datas);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

#pragma mark - notification
- (void)collectionDataDidChange:(NSNotification *)notification {
    NSDictionary * userInfo = notification.userInfo;
    if ([userInfo[@"didEnd"] boolValue]) {
        [_navView.titleLabel setText:_helper.currentCollectionTitle];
        [_navView setImageWithPHAsset:_helper.currentCollectionData[0]];
        [_collectionView reloadData];
    } else {
        NSLog(@"加载中");
    }
}

- (void)mutableClickCell:(NSNotification *)notification {
    RJPhotoCell * cell = notification.object;
    if (cell) {
        NSIndexPath * indexPath = [_collectionView indexPathForCell:cell];
        [_helper setSelectIndex:indexPath];
        [_collectionView reloadItemsAtIndexPaths:[_helper getCurrentCollectionSelectedArray]];
    }
}
#pragma mark - setter
- (void)setFinishBlock:(void(^)(NSArray<PHAsset *> * assets))block {
    _finishBlock = block;
}

- (void)setLineNumber:(NSInteger)lineNumber {
    _helper.lineNum = lineNumber;
}

- (void)setMaxSelectedNum:(NSInteger)maxNum {
    if (maxNum < 1) {
        return;
    }
    _helper.maxSelectCount = maxNum;
}

#pragma mark - getter
- (void)configCollectionView {

    [self configCollectionViewLayout];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_collectionView registerNib:[UINib nibWithNibName:@"RJPhotoCell" bundle:nil] forCellWithReuseIdentifier:RJPhotoPickerCellID];
    
    [_collectionView setContentInset:UIEdgeInsetsMake(_topViewHeightMax, 0, 0, 0)];
    
    RJWeak(self)
    [_collectionView setScrollBlock:^(CGFloat startY, CGFloat moveY, BOOL isEnd) {
        if (isEnd) {
            weakself.canDragLink = NO;
            weakself.dragDirection = RJDirectionUnknow;
            [weakself checkTouchEndPosition:moveY >= 0 ? RJDirectionDown : RJDirectionUp];
            return;
        }
        
        //此处的moveY是滑动过程中因边界弹簧效果偏移的量，及误差
        CGFloat top = weakself.collectionView.contentInset.top;
        CGFloat marginValue = weakself.collectionView.contentOffset.y + top;
        
        if (!weakself.canDragLink) {
            if ((startY + moveY) < marginValue) {
                //HalpScreen scroll to FullScreen
                weakself.canDragLink = YES;
                weakself.dragDirection = RJDirectionUp;
            } else if ((top >= weakself.topViewTopMax && moveY > 0)
                       && (top < weakself.topViewHeightMax)
                       && marginValue <= 0){
                weakself.canDragLink = YES;
                weakself.dragDirection = RJDirectionDown;
            }
        }
        
        if (weakself.canDragLink) {
            CGFloat exceedValue = marginValue - moveY - (weakself.dragDirection == RJDirectionUp ? startY : 0);
            CGFloat newTopValue = top - exceedValue;
            [weakself.collectionView setContentInset:UIEdgeInsetsMake(newTopValue, 0, 0, 0)];
            weakself.navViewTop.constant = -((SCHeight / 2) - newTopValue);
        }
    }];
    [_collectionView setHidden:NO];
}

- (void)configCollectionViewLayout {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat size = (SCWidth - _helper.lineNum + 1) / _helper.lineNum;
    layout.itemSize = CGSizeMake(size, size);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    [_collectionView setCollectionViewLayout:layout];
}

- (void)configNav {
    [_navView setDelegate:self];
    _navViewHeight.constant = _topViewHeightMax;
    _navView.navHeight.constant = DEVICE_NAV_HEIGHT;
    _navViewWidth.constant = SCWidth;
    RJWeak(self)
    [_navView.bottomView setTrackingBlock:^(BOOL stop, RJDirection direction, CGPoint changeValue) {
        if (stop) {
            [weakself checkTouchEndPosition:direction];
            return;
        }
        CGFloat top = weakself.collectionView.contentInset.top;
        CGFloat value = top + changeValue.y;
        if (value <= weakself.topViewTopMax
            || value >= weakself.topViewHeightMax) {
            return;
        }
        
        [weakself.collectionView setContentInset:UIEdgeInsetsMake(value, 0, 0, 0)];
        weakself.navViewTop.constant = - ((SCHeight / 2) - value);
    }];
    
    [_navView setHidden:NO];
    
    [_navView layoutIfNeeded];
}

- (RJAlbumChooseView *)getAlbumView {
    if (!_albumView) {
        RJWeak(self)
        _albumView = [[RJAlbumChooseView alloc] initWithFrame:CGRectMake(0, SCHeight, SCWidth, SCHeight - _topViewTopMax) albums:_helper.collectionData clickBlock:^(NSInteger index) {
            [weakself changeAlbumWithCount:index];
            [weakself setAlbumChooseViewShow:NO];
            [weakself.navView changeTitleImageWithSelected:NO];
        }];
        
        [_albumView setCurrentCount:_helper.currentCollectionCount];
    }
    return _albumView;
}
@end
