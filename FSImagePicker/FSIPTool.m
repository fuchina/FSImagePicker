//
//  FSIPTool.m
//  FSImage
//
//  Created by FudonFuchina on 2016/11/28.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSIPTool.h"

@implementation FSIPTool

+ (UIImage *)compressImage:(NSData *)imageData
{
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    if (![self isNeedCompress:imageData]) {
        return image;
    }
    NSInteger compressRate = 0;
    if ([self isPortait:image]) {
        compressRate = [self computeSampleSize:image minSideLength:750 maxNumOfPixels:1334 * 750];  // 安卓:1240 * 860
    }else{
        compressRate = [self computeSampleSize:image minSideLength:750 maxNumOfPixels:750 * 1334];
    }
#if DEBUG
    NSLog(@"压缩比:%@",@(compressRate));
#endif
    NSInteger width = image.size.width / compressRate;
    return [self compressImage:image targetWidth:width];
}

+ (NSInteger)computeSampleSize:(UIImage *)image minSideLength:(NSInteger)minSideLength maxNumOfPixels:(NSInteger)maxNumOfPixels
{
    NSInteger initialSize = [self computeInitialSampleSize:image minSideLength:minSideLength maxNumOfPixels:maxNumOfPixels];
    NSInteger roundedSize = 0;
    if (initialSize <= 8) {
        roundedSize = 1;
        while (roundedSize < initialSize) {
            roundedSize <<= 1;
        }
    }else{
        roundedSize = (initialSize + 7) / 8 * 8;
    }
    return roundedSize;
}

+ (NSInteger)computeInitialSampleSize:(UIImage *)image minSideLength:(NSInteger)minSideLength maxNumOfPixels:(NSInteger)maxNumOfPixels
{
    double w = image.size.width;
    double h = image.size.height;
    
    NSInteger lowerBound = (maxNumOfPixels == -1) ? 1 : (int)ceil(sqrt(w * h / maxNumOfPixels));
    NSInteger upperBound = (minSideLength == -1) ? 128 : (int) MIN(floor(w / minSideLength), floor(h / minSideLength));
    if (upperBound < lowerBound) {
        return lowerBound;
    }
    if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
        return 1;
    }else if (minSideLength == -1) {
        return lowerBound;
    } else {
        return upperBound;
    }
}

+ (BOOL)isNeedCompress:(NSData *)imageData
{
    return imageData.length > 500 * 1024;
}

+ (BOOL)isPortait:(UIImage *)image
{
    return image.size.height >= image.size.width;
}

+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth
{
    if (sourceImage.size.width < targetWidth) {
        return sourceImage;
    }
    CGFloat targetHeight = targetWidth * sourceImage.size.height / sourceImage.size.width;
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    UIGraphicsBeginImageContext(size);
    [sourceImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)KMGUnit:(NSInteger)size
{
    if (size >= (1024 * 1024 * 1024)) {
        return [[NSString alloc] initWithFormat:@"%.2f G",size / (1024 * 1024 * 1024.0f)];
    }else if (size >= (1024 * 1024)){
        return [[NSString alloc] initWithFormat:@"%.2f M",size / (1024 * 1024.0f)];
    }else{
        return [[NSString alloc] initWithFormat:@"%.2f K",size / 1024.0f];
    }
}

@end
