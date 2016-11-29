//
//  MSImagePickerController.h
//  Demo
//
//  Created by DamonDing on 15/5/14.
//  Copyright (c) 2015年 zxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSImagePickerController;

@protocol MSImagePickerDelegate<NSObject>

@optional
- (void)imagePickerControllerCustom:(MSImagePickerController *)picker didFinishPickingImage:(NSArray *)images;
- (void)imagePickerControllerDidCancelCustom:(MSImagePickerController *)picker;

@end

/**
 *  This class is just for select image
 */
@interface MSImagePickerController : UIImagePickerController


/**
 * save all selected image
 */
@property (strong, nonatomic) NSMutableArray* images;
@property (weak, nonatomic) id<MSImagePickerDelegate> msDelegate;
@property (assign , nonatomic) NSInteger maxSelectedImgsNum;

@end
