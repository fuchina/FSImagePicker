//
//  FSMoreImageCell.m
//  FSImage
//
//  Created by fudon on 2016/10/10.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSMoreImageCell.h"
#import "FSBeyondButton.h"
#import "FSImagePicker.h"

@interface FSMoreImageCell ()

@property (nonatomic,strong) UIImageView        *imageView;
@property (nonatomic,strong) FSBeyondButton     *button;

@end

@implementation FSMoreImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _button = [[FSBeyondButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 44, 0, 44, 44) center:NO];
        __weak FSMoreImageCell *this = self;
        _button.btnClickBlock = ^ (FSBeyondButton *bButton){
            if (this.btnClickBlock) {
                this.btnClickBlock(bButton,this.model);
            }
        };
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)setModel:(FSIPModel *)model {
    if (_model != model) {
        _model = model;
        
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 25) / 4;
        
        if (model.image) {
            _imageView.image = model.image;
        } else {
            [FSImagePicker thumbnailImageForModel:model completion:^(UIImage *bImage) {
                self.imageView.image = bImage;
            }];
        }
                
        _imageView.frame = CGRectMake(0, 0, width, width);
        _button.frame = CGRectMake(self.bounds.size.width - 44, 0, 44, 44);
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _button.isSelected = isSelected;
}

@end
