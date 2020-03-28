//
//  FSIPImageCell.h
//  FSImage
//
//  Created by fudon on 2016/11/28.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSIPImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^singleTapBlock)(void);

- (void)recoverSubviews;

@end
