//
//  FSMoreImageCell.h
//  FSImage
//
//  Created by fudon on 2016/10/10.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSAsset.h"
#import "FSBeyondButton.h"

@interface FSMoreImageCell : UICollectionViewCell

@property (nonatomic, strong) FSAsset  *model;
@property (nonatomic, copy)  void (^btnClickBlock)(FSBeyondButton *bButton,FSAsset *bModel);
@property (nonatomic, assign) BOOL              isSelected;

@end
