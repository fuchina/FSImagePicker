//
//  FSImagePicker.h
//  FSImage
//
//  Created by fudon on 2016/10/14.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSMoreImageModel.h"

@interface FSImagePicker : NSObject

@property (nonatomic,strong) NSArray<FSMoreImageModel *>    *selectedImages;

@property (nonatomic,strong) NSDictionary                   *allThumbnails;
@property (nonatomic,strong) NSArray<FSMoreImageModel*>     *allModels;

// 是否为原图
@property (nonatomic,assign) BOOL isOriginal;

// 获取所选择的图片的大小
- (NSInteger)sizeOfSelectedImages;

// 获取所有缩略图
- (NSDictionary *)getThumbnailImages;

// 稍微清晰的图片，但不是原图
- (FSMoreImageModel *)clearnessImageForModel:(FSMoreImageModel *)model;
- (void)clearnessImageForModel:(FSMoreImageModel *)model completion:(void(^)(FSMoreImageModel *bModel))completion;

// 获取模糊的小图
- (FSMoreImageModel *)thumbnailImageForModel:(FSMoreImageModel *)model;

// 请求资源
- (void)requestAllResources;

- (NSArray *)selectedAssetsWithModels;

- (NSArray *)selectedImagesWithModels;

- (NSInteger)compressWidthForImageWidth:(NSInteger)imageWidth;

@end
