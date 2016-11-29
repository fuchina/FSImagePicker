//
//  FSPreviewPhotoController.m
//  FSImage
//
//  Created by fudon on 2016/11/28.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSPreviewPhotoController.h"
#import "FSBeyondButton.h"
#import "FSButtonLabel.h"
#import "FSCountButton.h"
#import "FSBackButton.h"
#import "FSImagePicker.h"
#import "FSIPImageCell.h"
#import "UIView+Addition.h"
#import "FSIPTool.h"
#import "FSImagePickerController.h"

#define TAG_BUTTON  155

@interface FSPreviewPhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) FSBeyondButton *beyondButton;
@property (nonatomic,strong) FSCountButton  *countButton;
@property (nonatomic,strong) FSButtonLabel  *buttonLabel;
@property (nonatomic,strong) UIView         *naviBar;
@property (nonatomic,strong) UIView         *bottomView;
@property (nonatomic,assign) BOOL           isFullScreen;
@property (nonatomic,weak ) FSImagePickerController             *imageNavigationController;


@property (nonatomic,strong) UICollectionView   *collectionView;

@end

@implementation FSPreviewPhotoController

#if DEBUG
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
#endif

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageNavigationController = (FSImagePickerController *)self.navigationController;
    
    [self seeImageDesignViews];
    [self designBBIs];
    [self designBottomView];
    [self refreshUI];
}

- (void)designBBIs
{
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:34 / 255.0 green:34 / 255.0 blue:34 / 255.0 alpha:.7];
    [self.view addSubview:_naviBar];
    
    __weak FSPreviewPhotoController *this = self;
    FSBackButton *backButton = [[FSBackButton alloc] initWithFrame:CGRectMake(10, 20, 90, 44)];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tapBlock = ^ (FSBackButton *bButton){
        this.collectionView.frame = CGRectMake(0, 0, this.view.bounds.size.width, this.view.bounds.size.height);
        [this.navigationController popViewControllerAnimated:YES];
    };
    [_naviBar addSubview:backButton];
    
    _beyondButton = [[FSBeyondButton alloc] initWithFrame:CGRectMake(_naviBar.width - 54, 20, 44, 44)];
    _beyondButton.btnClickBlock = ^ (FSBeyondButton *bButton){
        [this handleSelectedModelsWithFlag:bButton];
    };
    FSImagePicker *picker = self.imageNavigationController.picker;
    FSIPModel *selectedModel = [_models objectAtIndex:_index];
    if ([picker.selectedImages containsObject:selectedModel]) {
        _beyondButton.isSelected = YES;
    }
    [_naviBar addSubview:_beyondButton];
}

- (void)designBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    [self.view addSubview:_bottomView];
    UIView *colorView = [[UIView alloc] initWithFrame:_bottomView.bounds];
    colorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    [_bottomView addSubview:colorView];
    
    FSImagePicker *picker = self.imageNavigationController.picker;
    __weak FSPreviewPhotoController *this = self;
    _buttonLabel = [[FSButtonLabel alloc] initWithFrame:CGRectMake(10, 0, 150, 50)];
    _buttonLabel.label.text = @"原图";
    [_bottomView addSubview:_buttonLabel];
    
    _buttonLabel.isOriginal = picker.isOriginal;
    _buttonLabel.label.textColor = [UIColor lightGrayColor];
    _buttonLabel.tapBlock = ^ (FSButtonLabel *bButton){
        if (this.tapBlock) {
            this.tapBlock(bButton.isOriginal);
        }
        bButton.label.textColor = [UIColor lightGrayColor];
        
        if (bButton.isOriginal) {
            FSIPModel *nowModel = [this.models objectAtIndex:this.index];
            if (nowModel.length) {
                NSString *sizeString = [[NSString alloc] initWithFormat:@"原图 (%@)",[FSIPTool KMGUnit:nowModel.length]];
                bButton.label.text = sizeString;
            }
            this.beyondButton.isSelected = YES;
            [this handleSelectedModelsWithFlag:this.beyondButton];
        }else{
            bButton.label.text = @"原图";
        }
    };
    
    _countButton = [[FSCountButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 0, 80, 50)];
    _countButton.textLabel.text = @"确定";
    [_bottomView addSubview:_countButton];
    _countButton.tapBlock = ^ (FSCountButton *bButton){
        if (this.queryBlock) {
            this.queryBlock();
        }
    };
}

- (void)seeImageDesignViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width + 20, self.view.bounds.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.bounds.size.width + 20, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.frame.size.width + 20), 0);
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[FSIPImageCell class] forCellWithReuseIdentifier:@"FSIPImageCell"];
    
    if (self.models.count > _index) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_index inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (FSIPImageCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FSIPImageCell";
    FSIPImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];    
    FSIPModel *model = self.models[indexPath.row];
    if (model.isMoreClear) {
        cell.image = model.image;
    }else{
        __weak FSIPImageCell *weakCell = cell;
        [self.imageNavigationController.picker clearnessImageForModel:model completion:^(UIImage *bImage) {
            weakCell.image = bImage;
        }];
    }
    
    __weak FSPreviewPhotoController *this = self;
    cell.singleTapBlock = ^ (){
        this.isFullScreen = !this.isFullScreen;
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[FSIPImageCell class]]) {
        [(FSIPImageCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[FSIPImageCell class]]) {
        [(FSIPImageCell *)cell recoverSubviews];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    _index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self indexChangeAction:_index];
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    if (_isFullScreen != isFullScreen) {
        _isFullScreen = isFullScreen;
        
        __weak FSPreviewPhotoController *this = self;
        [UIView animateWithDuration:.2 animations:^{
            this.naviBar.bottom = (!isFullScreen) * 64;
            _bottomView.top = self.view.height - 50 * !isFullScreen;
        }];
    }
}

- (void)handleSelectedModelsWithFlag:(FSBeyondButton *)bButton
{
    if (self.hasSelected) {
        if (self.models.count > self.index) {
            FSIPModel *nowModel = [self.models objectAtIndex:self.index];
            self.hasSelected(bButton,nowModel,self.index);
        }
        [self refreshUI];
    }
}

- (void)refreshUI
{
    FSImagePicker *picker = self.imageNavigationController.picker;
    _countButton.enabled = picker.selectedImages.count?YES:NO;
    _countButton.countLabel.text = @(picker.selectedImages.count).stringValue;
}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)indexChangeAction:(NSInteger)bIndex
{
    FSImagePicker *picker = self.imageNavigationController.picker;
    NSArray<NSIndexPath *> *indexPaths = [self.collectionView indexPathsForVisibleItems];
    if (indexPaths) {
        if (self.models.count > bIndex) {
            FSIPModel *model = [self.models objectAtIndex:bIndex];
            self.beyondButton.isSelected = [picker.selectedImages containsObject:model];
            
            if (self.buttonLabel.isOriginal) {
                NSString *sizeString = [[NSString alloc] initWithFormat:@"原图 (%@)",[FSIPTool KMGUnit:model.length]];
                self.buttonLabel.label.text = sizeString;
            }
        }
    }
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
