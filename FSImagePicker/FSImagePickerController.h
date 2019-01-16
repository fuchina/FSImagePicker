//
//  FSImagePickerController.h
//  FSImage
//
//  Created by fudon on 2016/10/14.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImagePicker.h"

@interface FSImagePickerController : UINavigationController

@property (nonatomic,strong) FSImagePicker  *picker;

// 图片选择张数，默认30张
@property (nonatomic,assign) NSInteger  imageCount;

// 选中的图片数组回调
@property (nonatomic,copy) void (^hasSelectImages)(NSArray<UIImage *> *photos,NSArray<PHAsset *> *assets);

+ (void)presentViewControllerFrom:(UIViewController *)baseController maxCount:(NSInteger)maxCount block:(void(^)(NSArray<UIImage *> *photos,NSArray<PHAsset *> *assets))block;

@end
