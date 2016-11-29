//
//  FSRunTime.h
//  FSImage
//
//  Created by fudon on 2016/11/18.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface FSRunTime : NSObject

// aClass类的aSEL方法和bClass的bSEL方法交换实现
+ (void)runtime_exchangeMethodWithClassA:(Class)aClass aSelector:(SEL)aSEL bClass:(Class)bClass bSelector:(SEL)bSEL;

// 为class类添加selector方法，这个方法来自于sourceClass中的ofSEL方法
+ (void)runtime_addMethodForClass:(Class)class selector:(SEL)selector fromClass:(Class)sourceClass ofSEL:(SEL)ofSEL;

@end
