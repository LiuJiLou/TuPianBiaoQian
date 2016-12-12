//
//  ShearViewController.h
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 2016/12/1.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "BasicViewController.h"

@class ShearViewController;

@protocol ShearViewControllerDelegate <NSObject>

- (void)imageCropper:(ShearViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(ShearViewController *)cropperViewController;

@end

@interface ShearViewController : BasicViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<ShearViewControllerDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

@property (nonatomic, copy) NSArray * dataArray;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
