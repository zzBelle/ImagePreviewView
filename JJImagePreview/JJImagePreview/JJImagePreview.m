//
//  JJImagePreview.m
//  JJImagePreview
//
//  Created by admin on 2019/8/8.
//  Copyright © 2019 JJ. All rights reserved.
//

#import "JJImagePreview.h"
//屏幕宽
#define S_ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高
#define S_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define S_IsIPhoneXAll (iPhoneXSeries())

CG_INLINE BOOL iPhoneXSeries(){
    BOOL iPhoneXSeries = NO;
    if(UIDevice.currentDevice.userInterfaceIdiom!=UIUserInterfaceIdiomPhone){
        return iPhoneXSeries;
    }
    if(@available(iOS 11.0,*)){
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        if(mainWindow.safeAreaInsets.bottom > 0.0){
            return YES;
        }
    }
    return iPhoneXSeries;
}


@interface JJImagePreview ()<UIScrollViewDelegate>

@end

@implementation JJImagePreview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.userInteractionEnabled = YES;
        // 添加子视图
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        // 页面控制
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - (S_IsIPhoneXAll ? 80 : 40), S_ScreenWidth, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)setPageNum:(NSInteger)pageNum {
    _pageNum = pageNum;
    _pageControl.numberOfPages = pageNum;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageIndex = scrollView.contentOffset.x / self.frame.size.width;
    _pageControl.currentPage = _pageIndex;
}
@end
