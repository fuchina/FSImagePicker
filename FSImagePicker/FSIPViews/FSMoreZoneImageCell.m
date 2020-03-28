//
//  FSMoreZoneImageCell.m
//  FSImage
//
//  Created by fudon on 2016/10/12.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSMoreZoneImageCell.h"
#import "FSImagePicker.h"

@implementation FSMoreZoneImageCell

- (void)setModel:(FSIPModel *)model {
    if (_model != model) {
        _model = model;
        [FSImagePicker thumbnailImageForModel:model completion:^(UIImage *bImage) {
            self.imageView.image = bImage;
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 70, 70);
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 80;
    self.textLabel.frame = tmpFrame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
