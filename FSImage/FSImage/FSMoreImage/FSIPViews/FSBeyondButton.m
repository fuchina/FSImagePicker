//
//  FSBeyondButton.m
//  FSImage
//
//  Created by fudon on 2016/10/10.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSBeyondButton.h"
#import "UIView+Addition.h"
#import "FSMoreImageHeader.h"

@interface FSBeyondButton ()

@property (nonatomic,strong) UILabel    *label;

@end

@implementation FSBeyondButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionBeyond)];
        [self addGestureRecognizer:tap];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
        _label.layer.masksToBounds = YES;
        _label.layer.cornerRadius = _label.height / 2;
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"✓";
        _label.layer.borderColor = [UIColor whiteColor].CGColor;
        _label.layer.borderWidth = 1;
        [self addSubview:_label];
        
        UIView *colorView = [[UIView alloc] initWithFrame:_label.bounds];
        colorView.layer.cornerRadius = colorView.height / 2;
        colorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
        [_label addSubview:colorView];
    }
    return self;
}

- (void)tapActionBeyond
{
    self.isSelected = !self.isSelected;
    if (_btnClickBlock) {
        _btnClickBlock(self);
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
        __weak FSBeyondButton *this = self;
        [UIView animateWithDuration:.6 delay:0.1 usingSpringWithDamping:.3 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            this.label.width = 30;
            this.label.height = 30;
            this.label.center = CGPointMake(this.width / 2, this.height / 2);
            this.label.layer.cornerRadius = this.label.width / 2;
        } completion:^(BOOL finished) {
            this.label.frame = CGRectMake(10, 10, 24, 24);
            this.label.layer.cornerRadius = this.label.height / 2;
            this.label.layer.borderColor = [UIColor whiteColor].CGColor;
        }];
    }else{
        self.label.backgroundColor = [UIColor clearColor];
        self.label.layer.borderColor = [UIColor whiteColor].CGColor;
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
