//
//  FSMoreImageModel.h
//  FSImage
//
//  Created by fudon on 2016/10/10.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface FSMoreImageModel : NSObject

@property (nonatomic,strong) PHAsset        *asset;
@property (nonatomic,strong) UIImage        *image;
@property (nonatomic,strong) NSDictionary   *info;
@property (nonatomic,assign) BOOL           isMoreClear;
@property (nonatomic,assign) NSInteger      length;

@end
