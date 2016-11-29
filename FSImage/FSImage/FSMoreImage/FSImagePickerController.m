//
//  FSImagePickerController.m
//  FSImage
//
//  Created by fudon on 2016/10/14.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSImagePickerController.h"
#import "FSMoreZoneImageController.h"
#import "FSAllImageController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FSImagePickerController ()

@end

@implementation FSImagePickerController

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (instancetype)initWithLimitCount:(NSInteger)maxCount
{
    _picker = [[FSImagePicker alloc] init];
    
    _imageCount = maxCount;
    FSMoreZoneImageController *zoneController = [[FSMoreZoneImageController alloc] init];
    self = [super initWithRootViewController:zoneController];
    if (self) {
        FSAllImageController *imagePicker = [[FSAllImageController alloc] init];
        [self pushViewController:imagePicker animated:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (BOOL)canVisitAlbum
//{
//    if (IOS(9)) {
//        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//                
//                if (status == PHAuthorizationStatusAuthorized) {
//                    
//                    // TODO:...
//                }
//            }];
//        }
//    }else{
//        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
//            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//                if (*stop) {
//                    // TODO:...
//                    return;
//                }
//                *stop = TRUE;//不能省略
//            } failureBlock:^(NSError *error) {
//                NSLog(@"failureBlock");
//            }];
//        }
//    }
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
