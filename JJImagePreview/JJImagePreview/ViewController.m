//
//  ViewController.m
//  JJImagePreview
//
//  Created by admin on 2019/8/8.
//  Copyright © 2019 JJ. All rights reserved.
//

#import "ViewController.h"
#import "JJImagePreview.h"
#import "JJSinglScrollView.h"

//屏幕宽
#define S_ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高
#define S_ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@property (nonatomic, strong) JJImagePreview *previewView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    
}

- (void)createView {
    _previewView = [[JJImagePreview alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

     NSArray *pics = @[@"IMG_J",@"IMG_Q",@"IMG_Y"];
    _imageViewsArray = [NSMutableArray array];
    CGFloat gap = 5;
    
        for (NSInteger i = 0; i < pics.count; i ++) {
            CGFloat SImageWidth = (S_ScreenWidth - 30 - 2 * gap) / pics.count;
            SImageView *image = [[SImageView alloc] initWithFrame:CGRectMake((SImageWidth + gap) * i + 15, 0, SImageWidth, 200)];
            
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.tag = 1000 + i;
            [image setClickHandler:^(SImageView *imageView){
                [self singleTapSmallViewCallback:imageView count:pics.count];
                if (self.singleTapHandler) {
                    self.singleTapHandler(imageView);
                }
            }];
            [image setImage:[UIImage imageNamed:pics[i]]];
            [_imageViewsArray addObject:image];
            [self.imageBgView addSubview:image];
        }
        _previewView.pageNum = pics.count;
        _previewView.scrollView.contentSize = CGSizeMake(_previewView.frame.size.width * pics.count, _previewView.frame.size.height);
}

- (void)singleTapSmallViewCallback:(SImageView *)imageView count:(NSInteger)count{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    // 解除隐藏
    [window addSubview:_previewView];
    [window bringSubviewToFront:_previewView];
    // 清空
    [_previewView.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加子视图
    NSInteger index = imageView.tag - 1000;
    CGRect convertRect;
    if (count == 1) {
        [_previewView.pageControl removeFromSuperview];
    }
    for (NSInteger i = 0; i < count; i ++) {
        // 转换Frame
//        SImageView *pImageView = (SImageView *)[self viewWithTag:1000+i];
        SImageView *pImageView = (SImageView *)[self.imageBgView viewWithTag:1000 +i];
        convertRect = [[pImageView superview] convertRect:pImageView.frame toView:window];
        // 添加
        JJSinglScrollView *scrollView = [[JJSinglScrollView alloc] initWithFrame:CGRectMake(i*_previewView.frame.size.width, 0, _previewView.frame.size.width, _previewView.frame.size.height)];
        scrollView.tag = 100+i;
        scrollView.maximumZoomScale = 2.0;
        scrollView.image = pImageView.image;
        scrollView.contentRect = convertRect;
        // 单击
        [scrollView setTapBigView:^(JJSinglScrollView *scrollView){
            [self singleTapBigViewCallback:scrollView];
        }];
        // 长按
        [scrollView setLongPressBigView:^(JJSinglScrollView *scrollView){
            
        }];
        [_previewView.scrollView addSubview:scrollView];
        if (i == index) {
            [UIView animateWithDuration:0.3 animations:^{
                self->_previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
                self->_previewView.pageControl.hidden = NO;
                [scrollView updateOriginRect];
            }];
        } else {
            [scrollView updateOriginRect];
        }
    }
    // 更新offset
    CGPoint offset = _previewView.scrollView.contentOffset;
    offset.x = index * S_ScreenWidth;
    _previewView.scrollView.contentOffset = offset;
    _previewView.pageControl.currentPage = index;
}

- (void)singleTapBigViewCallback:(JJSinglScrollView *)scrollView {
    [UIView animateWithDuration:0.3 animations:^{
        self->_previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self->_previewView.pageControl.hidden = YES;
        scrollView.contentRect = scrollView.contentRect;
        scrollView.zoomScale = 1.0;
    } completion:^(BOOL finished) {
        [self->_previewView removeFromSuperview];
    }];
}


@end

@implementation SImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:242.0/255 green:249.0/255 blue:255.0/255 alpha:1.0];
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds  = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGestureCallback:(UIGestureRecognizer *)gesture {
    if (self.clickHandler) {
        self.clickHandler(self);
    }
}

@end
