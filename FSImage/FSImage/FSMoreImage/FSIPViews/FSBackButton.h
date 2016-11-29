//
//  FSBackButton.h
//  FSImage
//
//  Created by fudon on 2016/10/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

/*
    1.建议长度为90以上，高度为44
 */

#import <UIKit/UIKit.h>

@interface FSBackButton : UIView

@property (nonatomic,copy) void (^tapBlock)(FSBackButton *bButton);

@end
