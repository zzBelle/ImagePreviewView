//
//  JJSinglScrollView.h
//  JJImagePreview
//
//  Created by admin on 2019/8/8.
//  Copyright © 2019 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJSinglScrollView : UIScrollView <UIScrollViewDelegate>
// 显示的大图
@property (nonatomic, strong) UIImageView *imageView;
// 原始Frame
@property (nonatomic, assign) CGRect originRect;
// 过程Frame
@property (nonatomic, assign) CGRect contentRect;

@property (nonatomic, strong) UIImage *image;
// 点击大图(关闭预览)
@property (nonatomic, copy) void (^tapBigView)(JJSinglScrollView *scrollView);
// 长按大图
@property (nonatomic, copy) void (^longPressBigView)(JJSinglScrollView *scrollView);

- (void)updateOriginRect;
@end

NS_ASSUME_NONNULL_END
