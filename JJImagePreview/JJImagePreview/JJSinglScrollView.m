//
//  JJSinglScrollView.m
//  JJImagePreview
//
//  Created by admin on 2019/8/8.
//  Copyright © 2019 JJ. All rights reserved.
//

#import "JJSinglScrollView.h"

//屏幕宽
#define S_ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高
#define S_ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation JJSinglScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.userInteractionEnabled = YES;
        self.minimumZoomScale = 1.0;
        self.bouncesZoom = YES;
        self.delegate = self;
        // 显示的图片
        [self addSubview:self.imageView];
        // 双击
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCallback:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        // 单击
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback:)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:singleTap];
        // 长按
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureCallback:)];
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithRed:242.0/255 green:249.0/255 blue:255.0/255 alpha:1.0];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    }
    return _imageView;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setContentRect:(CGRect)contentRect {
    _contentRect = contentRect;
    self.imageView.frame = contentRect;
}

- (void)updateOriginRect {
    CGSize picSize = self.imageView.image.size;
    if (picSize.width == 0 || picSize.height == 0) {
        return;
    }
    float scaleX = self.frame.size.width/picSize.width;
    float scaleY = self.frame.size.height/picSize.height;
    if (scaleX > scaleY) {
        float imgViewWidth = picSize.width*scaleY;
        self.maximumZoomScale = self.frame.size.width/imgViewWidth;
        _originRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    } else  {
        float imgViewHeight = picSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imgViewHeight;
        _originRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        self.zoomScale = 1.0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.imageView.frame = _originRect;
    }];
}

#pragma mark - TapGesture
- (void)doubleTapGestureCallback:(UITapGestureRecognizer *)gesture {
    CGFloat zoomScale = self.zoomScale;
    if (zoomScale == self.maximumZoomScale) {
        zoomScale = 0;
    } else {
        zoomScale = self.maximumZoomScale;
    }
    [UIView animateWithDuration:0.35 animations:^{
        self.zoomScale = zoomScale;
    }];
}

- (void)singleTapGestureCallback:(UITapGestureRecognizer *)gesture {
    if (self.tapBigView) {
        self.tapBigView(self);
    }
}

- (void)longPressGestureCallback:(UILongPressGestureRecognizer *)gesture {
    if (self.longPressBigView) {
        self.longPressBigView(self);
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    if (imgFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2;
    }
    if (imgFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2;
    }
    self.imageView.center = centerPoint;
}


@end
