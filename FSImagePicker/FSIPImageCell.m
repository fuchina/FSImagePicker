//
//  FSIPImageCell.m
//  FSImage
//
//  Created by fudon on 2016/11/28.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSIPImageCell.h"

@interface FSIPImageCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIView        *imageContainerView;

@end

@implementation FSIPImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;
        
        _imageView.image = image;
        [self resizeSubviews];
    }
}

//- (void)setModel:(TZAssetModel *)model {
//    _model = model;
//    [_scrollView setZoomScale:1.0 animated:NO];
//    [[TZImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//        self.imageView.image = photo;
//        [self resizeSubviews];
//    }];
//}

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews{
    UIImage *image = _imageView.image;
    if (image.size.width < 0.1) {
        return;
    }

    if (image.size.height / image.size.width > self.frame.size.height / self.scrollView.frame.size.width) {
        _imageContainerView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, floor(image.size.height / (image.size.width / self.scrollView.frame.size.width)));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.frame.size.width;
        if (height < 1 || isnan(height)) height = self.frame.size.height;
        height = floor(height);
        _imageContainerView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, height);
        _imageContainerView.center = CGPointMake(_imageContainerView.center.x, self.frame.size.height / 2);
    }
    if (_imageContainerView.frame.size.height > self.frame.size.height && _imageContainerView.frame.size.height - self.frame.size.height <= 1) {
        _imageContainerView.frame = CGRectMake(_imageContainerView.frame.origin.x, _imageContainerView.frame.origin.y, self.scrollView.frame.size.width, self.frame.size.height);
    }
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, MAX(_imageContainerView.frame.size.height, self.frame.size.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.frame.size.height <= self.frame.size.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end