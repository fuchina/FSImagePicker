//
//  FSRunTime.m
//  FSImage
//
//  Created by fudon on 2016/11/18.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSRunTime.h"

@implementation FSRunTime

// aClass类的aSEL方法和bClass的bSEL方法交换实现
+ (void)runtime_exchangeMethodWithClassA:(Class)aClass aSelector:(SEL)aSEL bClass:(Class)bClass bSelector:(SEL)bSEL
{
    if (aClass == nil || aSEL == nil || bClass == nil || bSEL == nil) {
        return;
    }
    Method aMethod = class_getInstanceMethod(aClass, aSEL);
    Method bMethod = class_getInstanceMethod(bClass, bSEL);
    method_exchangeImplementations(aMethod, bMethod);
}

// 为class类添加selector方法，这个方法来自于sourceClass中的ofSEL方法
+ (void)runtime_addMethodForClass:(Class)class selector:(SEL)selector fromClass:(Class)sourceClass ofSEL:(SEL)ofSEL
{
    if (class == nil || selector == nil || sourceClass == nil || ofSEL == nil) {
        return;
    }
    Method method = class_getInstanceMethod(sourceClass, ofSEL);
    class_addMethod(class, selector, method_getImplementation(method), method_getTypeEncoding(method));
}


@end
