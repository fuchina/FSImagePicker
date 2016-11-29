//
//  FSPhotoPickerController.m
//  FSImage
//
//  Created by fudon on 2016/11/18.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSPhotoPickerController.h"
#import "FSPPSelectView.h"
#import "FSRunTime.h"

static char attachSelfKey_Custom;

@interface FSPhotoPickerController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,weak)id                    showingViewController;
@property (retain, nonatomic)                   id lastDelegate;
@property (nonatomic,assign) NSIndexPath        *currentIndexPath;
@property (nonatomic,strong) NSArray            *images;
@property (retain, nonatomic) NSMutableArray    *indexPaths;
@property (assign, nonatomic) BOOL              exchangeMethod;
@property (retain, nonatomic) UIBarButtonItem   *lastDoneButton;

@end

@implementation FSPhotoPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)indexPaths
{
    if (_indexPaths == nil) {
        _indexPaths = [NSMutableArray new];
    }
    return _indexPaths;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.currentIndexPath = nil;
    
    self.showingViewController = viewController;
    NSLog(@"class:%@",[self.showingViewController class]);
    NSLog(@"subViews:%@",viewController.view.subviews);
    
    
    UIView* collection = [self getPUCollectionView:viewController.view];
    
    if (collection == nil) {
        if (self.exchangeMethod) {
            // reset method
            Method m2 = class_getInstanceMethod([self.lastDelegate class], @selector(override_collectionView:cellForItemAtIndexPath:));
            Method m3 = class_getInstanceMethod([self.lastDelegate class], @selector(collectionView:cellForItemAtIndexPath:));
            method_exchangeImplementations(m2, m3);
            
            self.exchangeMethod = NO;
        }
        return;
    }
    
    /**
     *  the collection base class is UICollectionView, so delegate, datasource ...
     */
    self.lastDelegate = [collection valueForKey:@"delegate"];
    [collection setValue:self forKey:@"delegate"];      // 让点击图片的回调在本类里执行
    
    [FSRunTime runtime_addMethodForClass:[self.lastDelegate class] selector:@selector(override_collectionView:cellForItemAtIndexPath:) fromClass:[self class] ofSEL:@selector(override_collectionView:cellForItemAtIndexPath:)]; // 给self.lastDelegate添加一个方法
    
    [FSRunTime runtime_exchangeMethodWithClassA:[self.lastDelegate class] aSelector:@selector(override_collectionView:cellForItemAtIndexPath:) bClass:[self.lastDelegate class] bSelector:   @selector(collectionView:cellForItemAtIndexPath:)]; // self.lastDelegate交换方法
    
    self.exchangeMethod = YES;
    objc_setAssociatedObject(self.lastDelegate, &attachSelfKey_Custom, self, OBJC_ASSOCIATION_ASSIGN); // 把self关联成self.lastDelegate的属性
    self.lastDoneButton = viewController.navigationItem.rightBarButtonItem;
}

- (Class) PUCollectionView {
    return NSClassFromString(@"PUCollectionView");
}

-(UIView*)getPUCollectionView:(UIView*)v
{
    for (UIView* i in v.subviews) {
        if ([i isKindOfClass:self.PUCollectionView]) {
            return i;
        }
    }
    return nil;
}

- (UICollectionViewCell *)override_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoPickerController *picker = (FSPhotoPickerController*)objc_getAssociatedObject(self, &attachSelfKey_Custom); // 这里的self不是指FSPhotoPickerController，而是self.lastDelegate
    UICollectionViewCell *cell = [self performSelector:@selector(override_collectionView:cellForItemAtIndexPath:) withObject:collectionView withObject:indexPath];
    
    FSPPSelectView *button = [picker makeButtonForView:cell];
    if (picker != nil) {
        picker.currentIndexPath = indexPath;
        button.isSelected = ([picker isCurIndexInIndexPaths] != -1);
    }
    return cell;
}

- (FSPPSelectView *)makeButtonForView:(UIView *)view
{
    NSInteger tag = 1000;
    FSPPSelectView *button = [view viewWithTag:tag];
    if (!button) {
        button = [[FSPPSelectView alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, 0, 40, 40)];
        button.tag = tag;
        [view addSubview:button];
        button.block = ^ (FSPPSelectView *bView){
            // 操作数据
            if (bView.isSelected) {
                
            }else{
                
            }
        };
    }
    return button;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%s", sel_getName(_cmd)]);
    if ([self.lastDelegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc -performSelector-leaks"
        [self.lastDelegate performSelector:sel withObject:collectionView withObject:indexPath];
#pragma clang diagnostic pop
    }
    
//    UIView* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    
//    UIButton* indicatorButton = [self getIndicatorButton:cell];
//    
//    if (indicatorButton == nil ) {
//        // do select(add button)  如果maxSelectedImgsNum ==1 替换所选图片
//        if (_limitNumbers == 1 && _limitNumbers == _images.count) {
//            NSIndexPath * firstIndexPath = (NSIndexPath*)self.indexPaths[0];
//            UIView* firstCell = [collectionView cellForItemAtIndexPath:firstIndexPath];
//            [self removeIndicatorButton:firstCell];
//            [self addIndicatorButton:cell];
//        }
//        if (_limitNumbers > _images.count) {
//            [self addIndicatorButton:cell];
//        }
//    } else {
//        // do deselect (remove button)
//        [self removeIndicatorButton:cell];
//        
//    }
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%s", sel_getName(_cmd)]);
//    if ([self.lastDelegate respondsToSelector:sel]) {
//        [self.lastDelegate performSelector:sel withObject:collectionView withObject:indexPath];
//    }
//#pragma clang diagnostic pop
    
    return YES;
}

- (void)dealloc
{
    if (self.exchangeMethod) {
        Method m2 = class_getInstanceMethod([self.lastDelegate class], @selector(override_collectionView:cellForItemAtIndexPath:));
        Method m3 = class_getInstanceMethod([self.lastDelegate class], @selector(collectionView:cellForItemAtIndexPath:));
        method_exchangeImplementations(m2, m3);
    }
}

- (int)isCurIndexInIndexPaths
{
    for (int i = 0; i < self.indexPaths.count; i++) {
        if (((NSIndexPath*)self.indexPaths[i]).row == self.currentIndexPath.row &&
            ((NSIndexPath*)self.indexPaths[i]).section == self.currentIndexPath.section) {
            return i;
        }
    }
    return -1;
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
