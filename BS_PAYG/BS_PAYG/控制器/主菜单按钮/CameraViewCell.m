//
//  cameraView.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/8.
//  Copyright © 2019 梁志华. All rights reserved.
//
//相机按钮图片的定义和初始化

#import "CameraViewCell.h"

@implementation CameraViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        //颜色度为1，透明度为0.5
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        //fill样式填充
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        //添加图片的view控制层
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}
@end
