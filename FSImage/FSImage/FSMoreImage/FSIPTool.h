//
//  FSIPTool.h
//  FSImage
//
//  Created by FudonFuchina on 2016/11/28.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FSIPTool : NSObject

// 压缩图片
+ (UIImage *)compressImage:(NSData *)imageData;

// 单位转换方法
+ (NSString *)KMGUnit:(NSInteger)size;

+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth;

@end
