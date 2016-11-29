//
//  FSCountButton.h
//  FSImage
//
//  Created by fudon on 2016/10/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCountButton : UIView

@property (nonatomic,assign) BOOL    enabled;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,copy) void (^tapBlock)(FSCountButton *bButton);

@end
