//
//  CustomAnnotationView.m
//  BaiduMap
//
//  Created by Edward on 16/9/28.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _imageView.image = [UIImage imageNamed:@"1"];
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
