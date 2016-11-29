//
//  FSPPSelectView.h
//  FSImage
//
//  Created by fudon on 2016/11/18.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPPSelectView : UIView

@property (nonatomic,assign) BOOL       isSelected;

@property (nonatomic,copy) void (^block)(FSPPSelectView *bView);

@end
