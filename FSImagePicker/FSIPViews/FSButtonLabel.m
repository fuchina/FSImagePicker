//
//  FSButtonLabel.m
//  FSImage
//
//  Created by fudon on 2016/10/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSButtonLabel.h"
#import "FSMoreImageHeader.h"

@implementation FSButtonLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionBL)];
        [self addGestureRecognizer:tap];
        
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height / 2 - 10, 20, 20)];
        _colorView.layer.cornerRadius = 10;
        _colorView.layer.borderWidth = 1;
        [self addSubview:_colorView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(25, frame.size.height / 2 - 20, frame.size.width - 25, 40)];
        _label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_label];
        
        [self unselectedStateUI];
    }
    return self;
}

- (void)tapActionBL
{
    self.isOriginal = !self.isOriginal;
    if (_tapBlock) {
        _tapBlock(self);
    }
}

- (void)setIsOriginal:(BOOL)isOriginal
{
    _isOriginal = isOriginal;
    if (isOriginal) {
        [self selectedStateUI];
    }else{
        [self unselectedStateUI];
    }
}

- (void)unselectedStateUI
{
    _colorView.backgroundColor = [UIColor clearColor];
    _colorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _colorView.frame = CGRectMake(0, self.frame.size.height / 2 - 10, 20, 20);
    _colorView.layer.cornerRadius = 10;

    _label.textColor = [UIColor grayColor];
}

- (void)selectedStateUI
{
    _colorView.backgroundColor = FSMoreGreenColor;
    _colorView.layer.borderColor = FSMoreGreenColor.CGColor;
    _colorView.frame = CGRectMake(5, self.frame.size.height / 2 - 7.5, 15, 15);
    _colorView.layer.cornerRadius = 7.5;
    
    _label.textColor = [UIColor blackColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
