//
//  FSButtonLabel.h
//  FSImage
//
//  Created by fudon on 2016/10/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSButtonLabel : UIView

@property (nonatomic,strong) UIView             *colorView;
@property (nonatomic,strong) UILabel            *label;
@property (nonatomic,assign) BOOL               isOriginal;
@property (nonatomic,copy)  void (^tapBlock)(FSButtonLabel *bButton);

@end
