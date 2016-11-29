//
//  FSMoreZoneImageCell.m
//  FSImage
//
//  Created by fudon on 2016/10/12.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSMoreZoneImageCell.h"

@implementation FSMoreZoneImageCell

- (void)setModel:(FSMoreImageModel *)model
{
    if (_model != model) {
        self.imageView.image = model.image;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 70, 70);
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
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
