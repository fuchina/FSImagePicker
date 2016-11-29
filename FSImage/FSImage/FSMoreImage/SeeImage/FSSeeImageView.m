//
//  FSSeeImageView.m
//  Picture
//
//  Created by fudon on 16/8/16.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSSeeImageView.h"
#import "FSSeeImageCell.h"

@interface FSSeeImageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@end

@implementation FSSeeImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self seeImageDesignViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<UIImage *> *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSource = dataSource;
        [self seeImageDesignViews];
    }
    return self;
}

- (void)setDataSource:(NSArray<UIImage *> *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        [_collectionView reloadData];
    }
}

- (void)seeImageDesignViews
{
    self.frame = [UIScreen mainScreen].bounds;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.bounds.size.width + 20, self.bounds.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(_dataSource.count * (self.bounds.size.width + 20), 0);
    
    [_collectionView registerClass:[FSSeeImageCell class] forCellWithReuseIdentifier:@"FSSeeImageCell"];
    [self addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (FSSeeImageCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FSSeeImageCell";
    FSSeeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UIImage *image = _dataSource[indexPath.row];
    if ([image isKindOfClass:[UIImage class]]) {
        cell.image = image;
    }
    __weak FSSeeImageView *this = self;
    cell.singleTapBlock = ^ (){
        [this singleBlockAction];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[FSSeeImageCell class]]) {
        [(FSSeeImageCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[FSSeeImageCell class]]) {
        [(FSSeeImageCell *)cell recoverSubviews];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    _index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    if (self.indexChangedBlock) {
        self.indexChangedBlock(self,_index);
    }
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    if (index < _dataSource.count) {
        CGFloat pageWidth = _collectionView.frame.size.width;
        _collectionView.contentOffset = CGPointMake(index * pageWidth, 0);
    }
}

- (void)singleBlockAction
{
    if (self.singleBlock) {
        self.singleBlock(self);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
