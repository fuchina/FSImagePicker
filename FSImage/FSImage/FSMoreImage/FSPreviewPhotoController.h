//
//  FSPreviewPhotoController.h
//  FSImage
//
//  Created by fudon on 2016/11/28.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMoreImageModel.h"

@class FSButtonLabel;
@class FSBeyondButton;
@interface FSPreviewPhotoController : UIViewController

@property (nonatomic,strong) NSArray        *models;
@property (nonatomic,assign) NSInteger      index;

@property (nonatomic,copy)  void (^tapBlock)(BOOL bIsOriginal);
@property (nonatomic,copy)  void (^hasSelected)(FSBeyondButton *bButton,FSMoreImageModel *bModel,NSInteger bIndex);
@property (nonatomic,copy)  void (^queryBlock)();

@end
