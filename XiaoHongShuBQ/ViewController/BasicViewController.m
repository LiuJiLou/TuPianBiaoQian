//
//  BasicViewController.m
//  Bolaihui
//
//  Created by zhilin duan on 7/29/15.
//  Copyright (c) 2015 Bolaihui. All rights reserved.
//

#import "BasicViewController.h"
#import "MBProgressHUD.h"

@class BNavgationBar;
@interface BasicViewController ()
{
    MBProgressHUD *HUD;
    BNavgationBar    *_naviBar;
	NSArray *_menuArray; //右上角菜单集合
    
    UIWebView *webView;
    NSURLRequest *request;
}

@end

@implementation BasicViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isback = NO;
        self.isvisible = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)createUI
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:GetImage(@"bg_bot_menu.png")]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBOne(0x73),NSForegroundColorAttributeName,GetFont(BFONT_18),NSFontAttributeName,nil]];

//    _naviBar = [[BNavgationBar alloc] init];
//    _naviBar.delegate = self;
//    [self.view addSubview:_naviBar];
    self.view.backgroundColor = [UIColor colorWithPatternImage:GetImage(@"bg_app.png")];
    if (SysVer >= 7.0) self.edgesForExtendedLayout = UIRectEdgeNone;
	
	_activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];//指定进度轮的大小
	
	[_activity setCenter:self.view.center];//指定进度轮中心点
	
	[_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
	
	[self.view addSubview:_activity];
}

-(void)stopActivityLoading
{
	if([_activity isAnimating]){
		
		[_activity stopAnimating];
		
	}
}

-(void)startActivityLoading
{
	[self.view bringSubviewToFront:_activity];
	[_activity startAnimating];
}


- (void)viewDidLayoutSubviews
{
//    CGSize size = self.view.frame.size;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.isvisible = YES;
//请求失败接收通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutBySystem:) name:NOTIFICATION_LOGOUT_BYSYSTEM object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    self.isvisible = NO;
    //请求失败接收通知
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGOUT_BYSYSTEM object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

}



- (void)showTextDialog:(NSString *)text {
    //初始化进度框，置于当前的View当中
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = text;
    
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1); // 睡眠1秒
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }
     ];
}

-(void)showCustomDialog:(NSString *)text {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jtour_select"]];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

- (void)showOnlyTextDialog:(NSString *)text {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
//    HUD.labelText = text;
    HUD.detailsLabelText = text;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //    HUD.yOffset = 150.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

- (void)showOnlyTextDialogOnWindow:(NSString *)text {
	HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
	[self.view addSubview:HUD];
	//    HUD.labelText = text;
	HUD.detailsLabelText = text;
	HUD.mode = MBProgressHUDModeText;
	
	//指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
	//    HUD.yOffset = 150.0f;
	//    HUD.xOffset = 100.0f;
	
	[HUD showAnimated:YES whileExecutingBlock:^{
		sleep(1);
	} completionBlock:^{
		[HUD removeFromSuperview];
		HUD = nil;
	}];
}


-(void)showLoadingView
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)dismissLoadingView
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)addBackNav
{
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"icon_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//    UIImage *backButtonImageHighted = [[UIImage imageNamed:@"icon_left_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImageHighted forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

@end
