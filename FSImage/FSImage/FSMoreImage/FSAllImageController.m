//
//  FSAllImageController.m
//  FSImage
//
//  Created by fudon on 2016/10/14.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSAllImageController.h"
#import "FSImagePicker.h"
#import "FSButtonLabel.h"
#import "FSMoreImageCell.h"
#import "FSPreviewPhotoController.h"
#import "FSMoreImageHeader.h"
#import "FSImagePickerController.h"
#import "FSCountButton.h"
#import "FSIPTool.h"

#define TAG_BUTTON  155

@interface FSAllImageController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView                   *collectionView;
@property (nonatomic,strong) UIView                             *bottomView;
@property (nonatomic,strong) FSButtonLabel                      *buttonLabel;
@property (nonatomic,strong) FSCountButton                      *countButton;
@property (nonatomic,strong) UIButton                           *button;
@property (nonatomic,weak ) FSImagePickerController             *imageNavigationController;

@end

static NSString *cellID = @"FSMoreImageCell";

@implementation FSAllImageController

#if DEBUG
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageNavigationController = (FSImagePickerController *)self.navigationController;
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.title) {
        self.title = @"所有照片";
    }
    
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(bbiLeftAction)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(bbiRightAction)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backView];
    
    [self moreImageHandleDatas];
}

- (void)moreImageHandleDatas
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FSImagePicker *instance = self.imageNavigationController.picker;
        if (!self.dataSource) {
            if (!instance.allModels.count) {
                [instance requestAllResources];
            }
            self.dataSource = instance.allModels;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self moreImageDesignViews];
        });
    });
}

- (void)moreImageDesignViews
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 25) / 4;
    CGFloat contentHeight = (self.dataSource.count / 4 + 1) * (width + 5);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(width,width);
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 70, self.view.bounds.size.width - 10, self.view.bounds.size.height - 120) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentSize = CGSizeMake(self.view.bounds.size.width - 10, MAX(self.view.bounds.size.height, contentHeight));
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[FSMoreImageCell class] forCellWithReuseIdentifier:@"FSMoreImageCell"];
    [self.view addSubview:_collectionView];
    [_collectionView setContentOffset:CGPointMake(0, contentHeight - 5) animated:NO];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    _bottomView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    [self.view addSubview:_bottomView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.bounds.size.width, .5f)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:lineView];
    
    FSImagePicker *manager = self.imageNavigationController.picker;
    NSArray *selectedImages = manager.selectedImages;
    BOOL hasSelectedImages = selectedImages.count?YES:NO;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(10, 5, 40, 40);
    [_button setTitle:@"预览" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _button.enabled = hasSelectedImages;
    _button.alpha = .5 + hasSelectedImages * .5;
    [_bottomView addSubview:_button];
    
    __weak FSAllImageController *this = self;
    _buttonLabel = [[FSButtonLabel alloc] initWithFrame:CGRectMake(60, 5, 150, 40)];
    _buttonLabel.isOriginal = manager.isOriginal;
    if (_buttonLabel.isOriginal && hasSelectedImages) {
        CGFloat bSize = [manager sizeOfSelectedImages];
        NSString *sizeString = [[NSString alloc] initWithFormat:@"原图 (%@)",[FSIPTool KMGUnit:bSize]];
        _buttonLabel.label.text = sizeString;
    }else{
        _buttonLabel.label.text = @"原图";
    }
    _buttonLabel.tapBlock = ^ (FSButtonLabel *bButton){
        [this changeIsOriginal:bButton.isOriginal];
    };
    [_bottomView addSubview:_buttonLabel];
    
    _countButton = [[FSCountButton alloc] initWithFrame:CGRectMake(_bottomView.bounds.size.width - 75, 4, 70, 40)];
    _countButton.textLabel.text = @"确定";
    _countButton.enabled = hasSelectedImages;
    if (hasSelectedImages) {
        _countButton.countLabel.text = @(selectedImages.count).stringValue;
    }
    [_bottomView addSubview:_countButton];
    _countButton.tapBlock = ^ (FSCountButton *bButton){
        [this queryAction];
    };
}

- (void)queryAction
{
    FSImagePicker *manager = self.imageNavigationController.picker;
    if (self.imageNavigationController.hasSelectImages) {// NSArray<UIImage *> *photos, NSArray *assets,
        self.imageNavigationController.hasSelectImages([manager selectedImagesWithModels],[manager selectedAssetsWithModels]);
        [self.imageNavigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)changeIsOriginal:(BOOL)isOriginal
{
    FSImagePicker *picker = self.imageNavigationController.picker;
    if (!picker.selectedImages.count) {
        _buttonLabel.isOriginal = NO;
        _buttonLabel.label.text = @"原图";
        picker.isOriginal = NO;
        return;
    }
    picker.isOriginal = isOriginal;
    
    if (picker.isOriginal) {
        CGFloat bSize = [picker sizeOfSelectedImages];
        NSString *sizeString = [[NSString alloc] initWithFormat:@"原图 (%@)",[FSIPTool KMGUnit:bSize]];
        _buttonLabel.label.text = sizeString;
    }else{
        _buttonLabel.label.text = @"原图";
    }
}

- (void)btnClick
{
    NSArray *selectedImages = self.imageNavigationController.picker.selectedImages;
    [self pushToBigPictureControllerWithImageArray:selectedImages index:0];
}

- (void)handleSelectedDatas:(FSBeyondButton *)bButton data:(FSIPModel *)bModel index:(NSInteger)bIndex
{
    FSImagePicker *picker = self.imageNavigationController.picker;
    if (bButton.isSelected) {
        NSArray *selectedImages = picker.selectedImages;
        BOOL isContain = [selectedImages containsObject:bModel];
        if ((selectedImages.count >= self.imageNavigationController.imageCount) && (!isContain)) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:[[NSString alloc] initWithFormat:@"最多上传%@张",@(self.imageNavigationController.imageCount)] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [controller addAction:doneAction];
            [self presentViewController:controller animated:YES completion:nil];
            bButton.isSelected = NO;
            return;
        }
        if (!isContain) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:selectedImages];
            [array addObject:bModel];
            picker.selectedImages = array;
        }
    }else{
        NSArray *selectedImages = picker.selectedImages;
        BOOL isContain = [selectedImages containsObject:bModel];
        if (isContain) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:selectedImages];
            [array removeObject:bModel];
            picker.selectedImages = array;
        }
    }
    
    if (bIndex >= 0) {
        [_collectionView reloadItemsAtIndexPaths:[_collectionView indexPathsForVisibleItems]];
    }
    
    NSArray *selectedImages = picker.selectedImages;
    _button.enabled = selectedImages.count?YES:NO;
    _button.alpha = selectedImages.count?1:.5;
    
    if (selectedImages.count) {
        _countButton.enabled = YES;
        _countButton.countLabel.text = @(selectedImages.count).stringValue;
    }else{
        _countButton.enabled = NO;
    }
    
    [self changeIsOriginal:_buttonLabel.isOriginal];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (FSMoreImageCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSMoreImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.isSelected = [self.imageNavigationController.picker.selectedImages containsObject:cell.model];
    __weak FSAllImageController *this = self;
    cell.btnClickBlock = ^ (FSBeyondButton *bButton,FSIPModel *bModel){
        [this handleSelectedDatas:bButton data:bModel index: -1];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToBigPictureControllerWithImageArray:self.imageNavigationController.picker.allModels index:indexPath.row];
}

- (void)pushToBigPictureControllerWithImageArray:(NSArray *)array index:(NSInteger)index
{
    FSPreviewPhotoController *bigController = [[FSPreviewPhotoController alloc] init];
    bigController.models = array;
    bigController.index = index;
    [self.navigationController pushViewController:bigController animated:YES];
    __weak FSAllImageController *this = self;
    bigController.tapBlock = ^ (BOOL bIsOriginal){
        this.buttonLabel.isOriginal = bIsOriginal;
        [this changeIsOriginal:bIsOriginal];
    };
    bigController.hasSelected = ^ (FSBeyondButton *bButton,FSIPModel *bModel,NSInteger bIndex){
        [this handleSelectedDatas:bButton data:bModel index:bIndex];
    };
    bigController.queryBlock = ^(){
        [this queryAction];
    };
}

- (void)bbiLeftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bbiRightAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataSource:(NSArray *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        [_collectionView reloadData];
    }
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
