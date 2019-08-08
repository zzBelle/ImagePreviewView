//
//  ViewController.h
//  JJImagePreview
//
//  Created by admin on 2019/8/8.
//  Copyright © 2019 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SImageView;

@interface ViewController : UIViewController
@property (nonatomic, copy) void (^singleTapHandler)(SImageView *imageView);

@end

@interface SImageView : UIImageView
@property (nonatomic, copy) void (^clickHandler)(SImageView *imageView);
@end
