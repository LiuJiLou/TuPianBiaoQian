//
//  BasicViewController.h
//  Bolaihui
//
//  Created by zhilin duan on 7/29/15.
//  Copyright (c) 2015 Bolaihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController


@property (nonatomic, assign) BOOL isback;
@property (nonatomic, assign) BOOL isvisible;

@property (nonatomic, assign) BOOL isNavgationBarHidden;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
- (void)createUI;

-(void)stopActivityLoading;
-(void)startActivityLoading;
/**
 *
 * 导航栏左键触发事件
 */
- (void)clickLeft;

/**
 *
 * 导航栏右键触发事件
 */
- (void)clickRight;

/**
 *
 * Toast提示
 *  @param text  需要显示的文本信息
 */
- (void)showTextDialog:(NSString *)text;

/**
 *  自定义Toast提示
 *
 *  @param text 需要显示的文本信息
 */
- (void)showCustomDialog:(NSString *)text;

/**
 *  显示只带文字的Toast
 *
 *  @param text
 */
- (void)showOnlyTextDialog:(NSString *)text;

/**
 *  弹出加载框
 */
-(void)showLoadingView;

/**
 *  关闭加载框
 */
-(void)dismissLoadingView;

/**
 *  返回按钮
 */
-(void)addBackNav;


@end
