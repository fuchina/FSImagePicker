//
//  FSPPSelectView.m
//  FSImage
//
//  Created by fudon on 2016/11/18.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSPPSelectView.h"
#import "UIView+Addition.h"

#define FSMoreGreenColor  [UIColor colorWithRed:31.0 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1]

@interface FSPPSelectView ()

@property (nonatomic,strong) UILabel    *label;

@end

@implementation FSPPSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        UIColor *color = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 24, 24)];
        _label.layer.cornerRadius = _label.frame.size.width / 2;
        _label.layer.borderColor = color.CGColor;
        _label.layer.borderWidth = 1.5;
        _label.layer.masksToBounds = YES;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"✓";
        _label.font = [UIFont boldSystemFontOfSize:15];
        _label.textColor = color;
        [self addSubview:_label];
    }
    return self;
}

- (void)tapAction
{
    self.isSelected = !self.isSelected;
    if (_block) {
        _block(self);
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected == isSelected) {
        return;
    }
    _isSelected = isSelected;
    if (isSelected) {
        self.label.backgroundColor = FSMoreGreenColor;
        
        [UIView animateWithDuration:.6 delay:0.1 usingSpringWithDamping:.3 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.label.width = 30;
            self.label.height = 30;
            self.label.center = CGPointMake(22, 17);    // 22 = 横坐标10 + 半径 12   纵坐标同理
            self.label.layer.cornerRadius = 15;
        } completion:^(BOOL finished) {
            self.label.frame = CGRectMake(10, 5, 24, 24);
            self.label.layer.cornerRadius = 12;
        }];
    }else{
        self.label.backgroundColor = [UIColor clearColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
