//
//  FSCountButton.m
//  FSImage
//
//  Created by fudon on 2016/10/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSCountButton.h"
#import "FSMoreImageHeader.h"
#import "UIView+Addition.h"

@implementation FSCountButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionCount)];
        [self addGestureRecognizer:tap];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height / 2 - 10, 20, 20)];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.layer.masksToBounds = YES;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = FSMoreGreenColor;
        _countLabel.layer.cornerRadius = 11;
        _countLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_countLabel];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, frame.size.height / 2 - 20, 40, 40)];
        _textLabel.textColor = FSMoreGreenColor;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)tapActionCount
{
    if (_enabled) {
        if (_tapBlock) {
            _tapBlock(self);
        }
    }
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    _countLabel.hidden = !enabled;
    if (enabled) {
        self.alpha = 1;
        
        [UIView animateWithDuration:.6 delay:0.1 usingSpringWithDamping:.3 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _countLabel.frame = CGRectMake(2.5, self.bounds.size.height / 2 - 12.5, 25, 25);
            _countLabel.layer.cornerRadius = 12.5;
        } completion:^(BOOL finished) {
            _countLabel.frame = CGRectMake(5, self.bounds.size.height / 2 - 10, 20, 20);
            _countLabel.layer.cornerRadius = 10;
        }];
    }else{
        self.alpha = .5;
        _countLabel.text = nil;
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
