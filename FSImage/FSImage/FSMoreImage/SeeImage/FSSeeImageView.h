//
//  FSSeeImageView.h
//  Picture
//
//  Created by fudon on 16/8/16.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSeeImageView : UIView

@property (nonatomic,strong) NSArray<UIImage *>     *dataSource;        // UIImage 对象数组
@property (nonatomic,assign) NSInteger              index;              // 展示第(index + 1)张图片
@property (nonatomic,copy) void                     (^singleBlock)(FSSeeImageView *bView);
@property (nonatomic,copy) void                     (^indexChangedBlock)(FSSeeImageView *bView,NSInteger bIndex);

@property (nonatomic,strong) UICollectionView       *collectionView;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<UIImage *> *)dataSource;    // 数组传入UIImage对象

@end
