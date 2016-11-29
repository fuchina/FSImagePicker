//
//  ViewController.m
//  FSImage
//
//  Created by fudon on 2016/10/9.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "ViewController.h"
#import "FSMoreZoneImageController.h"
#import "FSImagePickerController.h"
#import "FSPhotoPickerController.h"
#import "MSImagePickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 200, 40);
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"afe" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)btnClick
{
//    FSPhotoPickerController *pp = [[FSPhotoPickerController alloc] init];
//    [self presentViewController:pp animated:YES completion:^{
//        
//    }];
    
//    MSImagePickerController *pp = [[MSImagePickerController alloc] init];
//    [self presentViewController:pp animated:YES completion:^{
//        
//    }];
//    return;
    FSImagePickerController *moreImageController = [[FSImagePickerController alloc] initWithLimitCount:100];
    [self presentViewController:moreImageController animated:YES completion:nil];
    moreImageController.hasSelectImages = ^(NSArray<UIImage *> *photos,NSArray<PHAsset *> *assets){
        for (int x = 0; x < photos.count; x ++) {
            UIImage *image = photos[x];
            NSLog(@"%@",image);
        }
    };
}

+ (void)pushToViewControllerWithClass:(NSString *)className navigationController:(UINavigationController *)navigationController param:(NSDictionary *)param configBlock:(void (^)(UIViewController *vc))configBlockParam
{
    Class Controller = NSClassFromString(className);
    if (Controller) {
        UIViewController *viewController = [[Controller alloc] init];
        //... 根据字典给属性赋值
        
        if (configBlockParam) {
            configBlockParam(viewController);
        }
        [navigationController pushViewController:viewController animated:YES];
    }
}

+ (void)presentToViewControllerWithClass:(NSString *)className controller:(UIViewController *)viewController param:(NSDictionary *)param configBlock:(void (^)(UIViewController *vc))configBlockParam presentCompletion:(void(^)(void))completion
{
    Class Controller = NSClassFromString(className);
    if (Controller) {
        UIViewController *presentViewController = [[Controller alloc] init];
        //... 根据字典给属性赋值
        
        if (configBlockParam) {
            configBlockParam(presentViewController);
        }
        [viewController presentViewController:presentViewController animated:YES completion:completion];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
