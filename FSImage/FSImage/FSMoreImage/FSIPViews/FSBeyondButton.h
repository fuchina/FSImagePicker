//
//  FSBeyondButton.h
//  FSImage
//
//  Created by fudon on 2016/10/10.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSBeyondButton : UIView

@property (nonatomic,assign) BOOL       isSelected;
@property (nonatomic, copy)  void (^btnClickBlock)(FSBeyondButton *bButton);

- (instancetype)initWithFrame:(CGRect)frame center:(BOOL)center;

@end
