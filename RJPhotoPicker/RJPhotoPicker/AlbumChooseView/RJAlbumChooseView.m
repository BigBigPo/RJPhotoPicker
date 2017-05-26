//
//  RJAlbumChooseView.m
//  RJPhotoPicker
//
//  Created by Po on 2016/11/24.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "RJAlbumChooseView.h"
#import "RJAlbumCell.h"


static NSString * const RJAlbumChooseCellID = @"AlbumChooseCellID";

typedef void(^RJAlbumClickBlcok)(NSInteger index);

@interface RJAlbumChooseView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray * albumsArray;
@property (copy, nonatomic) RJAlbumClickBlcok clickBlock;

@property (assign, nonatomic) NSInteger currentCount;

@end

@implementation RJAlbumChooseView
- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame albums:(NSArray *)albums clickBlock:(void(^)(NSInteger index))block{
    self = [super initWithFrame:frame];
    if (self) {
        _albumsArray = [NSArray arrayWithArray:albums];
        _clickBlock = block;
        _currentCount = -1;
        [self initInterface];
    }
    return self;
}

#pragma mark - user-define initialization
- (void)initInterface {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerNib:[UINib nibWithNibName:@"RJAlbumCell" bundle:nil] forCellReuseIdentifier:RJAlbumChooseCellID];
    [self addSubview:_tableView];
}

#pragma mark - event

#pragma mark - function
- (void)setCurrentCount:(NSInteger)count {
    if (count > 0 && count < _albumsArray.count) {
        _currentCount = count;
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentCount inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - delegate

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_clickBlock) {
        _clickBlock(indexPath.row);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RJAlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:RJAlbumChooseCellID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RJAlbumCell * myCell = (RJAlbumCell *)cell;
    NSDictionary * album = _albumsArray[indexPath.row];
    
    NSArray * photos = [[album allValues] lastObject];
    
    NSString * title = [[album allKeys] lastObject];
    NSString * detail = [NSString stringWithFormat:@"%ld",photos.count];
    [myCell.rj_titleLabel setText:title];
    [myCell.rj_detailLabel setText:detail];
    
    if (photos.count > 0) {
        id photo = photos[0];
        [myCell setImageAsset:photo];
    }
    
    [myCell.selectedStateImage setHidden:_currentCount != indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


@end
