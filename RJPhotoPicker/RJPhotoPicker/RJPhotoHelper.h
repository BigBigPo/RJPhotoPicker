//
//  RJPhotoHelper.h
//  RJPhotoPicker_OC
//
//  Created by Po on 16/7/25.
//  Copyright © 2016年 Po. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>



@interface RJPhotoHelper : NSObject
@property (strong, nonatomic) NSArray<NSDictionary *> * collectionData;             //all collection data

@property (assign, nonatomic) NSInteger currentCollectionCount;                     //current collection count
@property (strong, nonatomic) NSString* currentCollectionTitle;                     //current collection title
@property (strong, nonatomic) NSArray<PHAsset*>* currentCollectionData;             //current collection data array
@property (strong, nonatomic) NSMutableArray<NSIndexPath*> * selectedArray;         //current selected array,【the section is Collection num】;

@property (assign, nonatomic) NSInteger currentAssetCount;                          //current selected count
@property (assign, nonatomic) NSInteger maxSelectCount;                             //maximum selected, default is 10;

@property (assign, nonatomic) NSInteger lineNum;                                    //line number

@property (strong, nonatomic) NSMutableArray * imagesArray;                         //Catch
/**get all data*/
- (void)getAllPhotoData;

/**set selected Array*/
- (void)setSelectIndex:(NSIndexPath *)indexPath;
- (NSArray *)getCurrentCollectionSelectedArray;

/**set selected collection count*/
- (void)setSelectCollectionCount:(NSInteger)count;

/**check permission*/
- (void)getPhotoPermission:(void(^)(BOOL havePower))resultBlock;

- (NSArray *)getAllAssetWithSelectedArray;

- (PHAsset *)getAssetWithCollectionCount:(NSInteger)count row:(NSInteger)row;
@end
