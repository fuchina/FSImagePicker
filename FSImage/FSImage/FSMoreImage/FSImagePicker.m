//
//  FSImagePicker.m
//  FSImage
//
//  Created by fudon on 2016/10/14.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSImagePicker.h"
#import <Photos/Photos.h>
#import <math.h>
#import "FSIPTool.h"

@implementation FSImagePicker

#if DEBUG
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
#endif

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self requestAllResources];
    }
    return self;
}

- (void)requestAllResources
{
    _allThumbnails = [self getThumbnailImages];
    _allModels = [self parseArrayFromDictionary:_allThumbnails];
}

- (NSArray *)parseArrayFromDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    for (int x = 0; x < keys.count; x ++) {
        NSArray *array = [dic objectForKey:keys[x]];
        [dataSource addObjectsFromArray:array];
    }
    return dataSource;
}

- (NSInteger)sizeOfSelectedImages
{
    __block CGFloat imageLength = 0;
    for (int x = 0; x < _selectedImages.count; x ++) {
        FSIPModel *model = [_selectedImages objectAtIndex:x];
        if (model.length) {
            imageLength += model.length;
        }else{
            imageLength += [self sizeForImageWithAsset:model.asset];
        }
    }
    return imageLength;
}

// 稍微清晰的图片，但不是原图
- (FSIPModel *)clearnessImageForModel:(FSIPModel *)model
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGFloat sizeWidth = model.asset.pixelWidth;
    CGFloat sizeHeight = model.asset.pixelHeight;
    
    if (model.asset.pixelWidth > [UIScreen mainScreen].bounds.size.width * 2) {
        sizeWidth = [UIScreen mainScreen].bounds.size.width * 2;
        sizeHeight = sizeWidth * model.asset.pixelHeight / model.asset.pixelWidth;
    }
    CGSize size = CGSizeMake(sizeWidth, sizeHeight);
    
    // 从asset中获得图片
    __block __weak FSIPModel *value = model;
    __weak FSImagePicker *this = self;
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        value.image = result;
        value.info = info;
        value.isMoreClear = YES;
        value.length = [this sizeForImageWithAsset:model.asset];
    }];
    return value;
}

// 稍微清晰的图片，但不是原图
- (void)clearnessImageForModel:(FSIPModel *)model completion:(void(^)(FSIPModel *bModel))completion
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGFloat sizeWidth = model.asset.pixelWidth;
    CGFloat sizeHeight = model.asset.pixelHeight;
    
    if (model.asset.pixelWidth > [UIScreen mainScreen].bounds.size.width * 2) {
        sizeWidth = [UIScreen mainScreen].bounds.size.width * 2;
        sizeHeight = sizeWidth * model.asset.pixelHeight / model.asset.pixelWidth;
    }
    CGSize size = CGSizeMake(sizeWidth, sizeHeight);
    
    // 从asset中获得图片
    __block __weak FSIPModel *value = model;
    __weak FSImagePicker *this = self;
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined) {
            value.image = result;
            NSLog(@"%@",result);
            value.info = info;
            value.isMoreClear = YES;
            value.length = [this sizeForImageWithAsset:model.asset];
            if (completion) {
                completion(value);
            }
        }
    }];
}


- (NSInteger)sizeForImageWithAsset:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    __block NSInteger length = 0;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        length = imageData.length;
        for (int x = 0; x < self.selectedImages.count; x ++) {
            FSIPModel *model = self.selectedImages[x];
            if (model.asset == asset) {
                model.length = length;
            }
        }
    }];
    return length;
}

- (NSArray *)selectedAssetsWithModels
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_selectedImages.count];
    for (int x = 0; x < _selectedImages.count; x ++) {
        FSIPModel *model = [_selectedImages objectAtIndex:x];
        if (model.asset) {
            [array addObject:model.asset];
        }
    }
    return array;
}

- (NSArray *)selectedImagesWithModels
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_selectedImages.count];
    for (int x = 0; x < _selectedImages.count; x ++) {
        FSIPModel *model = [_selectedImages objectAtIndex:x];
        if (model.asset) {
            NSData *imageData = [self imageForModel:model];
            if (!_isOriginal) {
                UIImage *image = [FSIPTool compressImage:imageData];
                if (image) {
                    [array addObject:image];
                }
            }else{
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                if (image) {
                    [array addObject:image];
                }
            }
        }
    }
    return array;
}

- (NSData *)imageForModel:(FSIPModel *)model
{
    if (!model.asset) {
        return nil;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    __block __weak NSData *data = nil;
    [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        data = imageData;
    }];
    return data;
}

// 获取所有图片的Model
- (NSDictionary *)getThumbnailImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (PHAssetCollection *assetCollection in assetCollections) {
        NSString *name = assetCollection.localizedTitle;
        NSArray *array = [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        if (name.length == 0) {
            name = @"自定义相册";
        }
        if (array) {
            NSArray *keys = [dic allKeys];
            if (![keys containsObject:name]) {
                [dic setObject:array forKey:name];
            }else{
                NSMutableArray *subArray = [[NSMutableArray alloc] initWithArray:[dic objectForKey:name]];
                [subArray addObjectsFromArray:array];
                [dic setObject:subArray forKey:name];
            }
        }
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    NSArray *array = [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
    NSString *name = cameraRoll.localizedTitle;
    if (name.length == 0) {
        name = @"相机胶卷";
    }
    if (array) {
        NSArray *keys = [dic allKeys];
        if (![keys containsObject:name]) {
            [dic setObject:array forKey:name];
        }else{
            NSMutableArray *subArray = [[NSMutableArray alloc] initWithArray:[dic objectForKey:name]];
            [subArray addObjectsFromArray:array];
            [dic setObject:subArray forKey:name];
        }
    }
    return dic;
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (NSArray *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    //    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:assets.count];
    for (PHAsset *asset in assets) {
        if (asset.mediaType != PHAssetMediaTypeImage) {
            continue;
        }
        if (asset.pixelWidth == 0) {
            continue;
        }
        
        FSIPModel *model = [[FSIPModel alloc] init];
        model.image = nil;
        model.info = nil;
        model.asset = asset;
        [array addObject:model];
    }
    return array;
}

void getImgWidth(long *width , int * index)
{
    if (*width < 160) {
        return ;
    }
    (*index) ++;
    *width /= 2;
    getImgWidth(width,index);
}

- (NSInteger)compressWidthForImageWidth:(NSInteger)imageWidth
{
    int  index = 0;
    getImgWidth(&imageWidth, &index);
    return index;
}

@end
