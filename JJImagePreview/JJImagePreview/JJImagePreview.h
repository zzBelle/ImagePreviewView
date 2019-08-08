//
//  JJImagePreview.h
//  JJImagePreview
//
//  Created by admin on 2019/8/8.
//  Copyright © 2019 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJImagePreview : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageIndex;

@end

NS_ASSUME_NONNULL_END
