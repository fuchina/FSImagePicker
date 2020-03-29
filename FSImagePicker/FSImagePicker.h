//
//  FSImagePicker.h
//  FSImage
//
//  Created by fudon on 2016/10/14.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAsset.h"

@interface FSImagePicker : NSObject

@property (nonatomic,strong) NSArray<FSAsset*>     *selectedImages;

@property (nonatomic,strong) NSDictionary            *allThumbnails;
@property (nonatomic,strong) NSArray<FSAsset*>     *allModels;

// 是否为原图
@property (nonatomic,assign) BOOL isOriginal;

// 请求资源
- (void)requestAllResources;

// 获取所选择的图片的大小
- (NSInteger)sizeOfSelectedImages;

// 获取所有缩略图
- (NSDictionary *)getThumbnailImages;

// 稍微清晰的图片，但不是原图
+ (void)clearnessImageForModel:(FSAsset *)model completion:(void(^)(UIImage *bImage))completion;

// 获取缩略图
+ (void)thumbnailImageForModel:(FSAsset *)model completion:(void(^)(UIImage *bImage))completion;

// 图片大小
+ (void)imageDataWithAsset:(PHAsset *)asset completion:(void(^)(NSData *data))completion;

- (NSArray *)selectedAssetsWithModels;

- (NSArray *)selectedImagesWithModels;


@end
