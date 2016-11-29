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

#if DEBUG
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
#endif

+ (void)presentViewControllerFrom:(UIViewController *)baseController maxCount:(NSInteger)maxCount block:(void(^)(NSArray<UIImage *> *photos,NSArray<PHAsset *> *assets))block
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
            {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"没有相册权限" message:@"请去相册中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                [controller addAction:doneAction];
                [baseController presentViewController:controller animated:YES completion:nil];
            }else if (status == PHAuthorizationStatusAuthorized){
                FSImagePickerController *moreImageController = [[FSImagePickerController alloc] initWithLimitCount:maxCount];
                [baseController presentViewController:moreImageController animated:YES completion:nil];
                moreImageController.hasSelectImages = ^(NSArray<UIImage *> *photos,NSArray<PHAsset *> *assets){
                    if (block) {
                        block(photos,assets);
                    }
                };
            }
        });
    }];
}

- (instancetype)initWithLimitCount:(NSInteger)maxCount
{
    FSMoreZoneImageController *zoneController = [[FSMoreZoneImageController alloc] init];
    self = [super initWithRootViewController:zoneController];
    _picker = [[FSImagePicker alloc] init];
    _imageCount = maxCount;
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
