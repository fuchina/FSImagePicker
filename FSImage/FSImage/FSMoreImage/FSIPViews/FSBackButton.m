//
//  FSBackButton.m
//  FSImage
//
//  Created by fudon on 2016/10/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSBackButton.h"

@implementation FSBackButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionCount)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapActionCount
{
    if (_tapBlock) {
        _tapBlock(self);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 2);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 250 / 255.0, 250 / 255.0, 250 / 255.0, 1.0);  //线的颜色
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 20, self.frame.size.height / 2 - 10);  //起点坐标
    CGContextAddLineToPoint(context, 10, self.frame.size.height / 2);
    CGContextAddLineToPoint(context, 20, self.frame.size.height / 2 + 10);   //终点坐标
    
    CGContextStrokePath(context);
}

@end
