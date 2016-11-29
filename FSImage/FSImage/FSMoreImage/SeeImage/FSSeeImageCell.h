//
//  FSSeeImageCell.h
//  Picture
//
//  Created by fudon on 16/8/18.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSeeImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^singleTapBlock)();

- (void)recoverSubviews;

@end
