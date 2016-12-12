//
//  MP4ViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/10/27.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "MP4ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "KrVideoPlayerController.h"
#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"

@interface MP4ViewController ()

@property (nonatomic, strong) UIButton *prepareButton;
@property (nonatomic, strong) UIButton *makeButton;



//第三方视频播放器
@property (nonatomic, strong) KrVideoPlayerController  *videoController;

#warning **** 9.0GengHuan  ShiPinBoFangQi
//视频播放管理（由于AVPlayerViewController是9.0之后才开始使用，所以仍用MPMoviePlayerViewController 需要包含头文件 #import <MediaPlayer/MediaPlayer.h>）
@property(nonatomic)MPMoviePlayerViewController * mpm;
//返回网络状态
@property(nonatomic)NSInteger monitor;

//判断点击的是材料准备，还是制作过程
@property(nonatomic)NSInteger judge;

//判断是否联网，不联网不能放视频
@property(nonatomic)BOOL isOk;

//屏幕遮挡视图
@property(nonatomic)UIImageView * imageView1;

@end

@implementation MP4ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"视频详情";
     //详情视图
    [self customView];
}

//布局详情视图
-(void)customView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"播放" style:UIBarButtonItemStylePlain target:self action:@selector(playMakeFoodVideo)];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

//-------------------------------------
#pragma mark -
#pragma mark - 视频播放
//制作过程
- (void)playMakeFoodVideo
{
    self.judge = 1002;
    //提示框
    [self showOkayCancelAlert];
}

//*************************************************
//------------------------------------------------------
//网络状态提示框
- (void)showOkayCancelAlert
{
    //NSLocalizedString 本地化字符串（系统宏）
    //在源代码中使用NSLocalizedString来引用国际化文件
    //提示头
    NSString *title = NSLocalizedString(@"视频", nil);
    
    //判断网络状态
    [self netMonitor];
    
    NSString * montiorStr = [[NSString alloc]init];
    if (self.monitor == 2) {
        montiorStr = @"当前没有连接网络，请连接网络";
        self.isOk = NO;
    }else if (self.monitor == 3){
        montiorStr = @"当前为移动网络，确定要播放掌厨视频吗？";
        self.isOk = YES;
    }else if (self.monitor == 4){
        montiorStr = @"当前为WIFI网络，请点击确定播放视频";
        self.isOk = YES;
    }else{
        montiorStr = @"当前网络状态未知，确定要播放视频吗？";
        self.isOk = YES;
    }
    
    //    NSString *message = NSLocalizedString(@"当前为移动网络", nil);
    NSString *message = [montiorStr copy];
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    //初始化提示框添加提示内容
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //点击取消键响应
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"点击了取消按钮");
    }];
    
    //点击确认件响应
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
        if (self.isOk) {
            if (self.judge ==1001) {
                //拼接准备材料的数据路径
                NSString * playUrl = @"http://flv2.bn.netease.com/videolib3/1610/28/efghA7006/SD/efghA7006-mobile.mp4";
                
                [self playVideoWithUrl:playUrl];
 
            }else{
                //拼接制作过程的数据路径
                NSString * playUrl = @"http://flv2.bn.netease.com/videolib3/1610/28/efghA7006/SD/efghA7006-mobile.mp4";
                
                [self playVideoWithUrl:playUrl];
            }
        }
    }];
    
    //添加按钮到提示框
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    //模态推出提示框
    [self presentViewController:alertController animated:YES completion:nil];
}

//*************************************************
#pragma mark -第三方库视频播放器
//第三方库视频播放器
-(void)playVideoWithUrl:(NSString *)url
{
    [self addVideoPlayerWithURL:[NSURL URLWithString:url]];
}

- (void)addVideoPlayerWithURL:(NSURL *)url
{
    if (!self.videoController)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(13.0/18.0))];
        [self VerticalScreenImageView];
        __weak typeof(self)weakSelf = self;
        
        //退出视频播放
        [self.videoController setDimissCompleteBlock:^{
            
            weakSelf.videoController = nil;
        }];
        
        //将退出全屏模式
        [self.videoController setWillBackOrientationPortrait:^{
            
            weakSelf.imageView1.frame = CGRectMake(0, 56, 45, 45);
            [weakSelf toolbarHidden:NO];
        }];
        
        //将要全屏显示
        [self.videoController setWillChangeToFullscreenMode:^{
            
            weakSelf.imageView1.frame = CGRectMake(0, 40, 80, 80);
            
            [weakSelf toolbarHidden:YES];
            
            //隐藏状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
        
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    
}

//是否隐藏导航栏
- (void)toolbarHidden:(BOOL)Bool{
    self.navigationController.navigationBar.hidden = Bool;
    //    self.tabBarController.tabBar.hidden = Bool;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.videoController dismiss];
}

//屏幕遮挡视图
-(void)VerticalScreenImageView
{
    _imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon.png"]];
    _imageView1.frame = CGRectMake(0, 56, 45, 45);
    [self.videoController.view addSubview:_imageView1];
}

//*************************************************
//------------------------------------------------
//判断网络状态
-(void)netMonitor
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.monitor = 1;
                NSLog(@"状态未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.monitor = 2;
                NSLog(@"网络不通");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.monitor = 3;
                NSLog(@"网络为2G/3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.monitor = 4;
                NSLog(@"网络为WIFI");
                break;
            default:
                break;
        }
    }];
}
//-------------------------------------------------------
//视频播放
-(void)playVideo:(NSString *)playUrl
{
    self.mpm = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:playUrl]];
    
    //视频播放器，可以播放
    self.mpm.moviePlayer.shouldAutoplay = YES;
    
    //准备播放
    [self.mpm.moviePlayer prepareToPlay];
    
    //播放
    [self.mpm.moviePlayer play];
    
    //通知中心默认中心
    //增加观察者:自身 self
    //响应方法:@ selector(视频播放结束:)(传得时通知NSNotification )
    //名称:视频播放器播放并完成通知
    //对象:nil
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    //模态推出视频播放器
    [self presentViewController:self.mpm animated:YES completion:nil];
}

//通知中心通知的播放结束
-(void)playEnd:(NSNotification *)notify
{
    //原因 reason
    //通知用户信息
    //对象的关键:视频播放器播放并完成原因的关键用户信息
    //整数值
    NSInteger reason = [[[notify userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    
    //打印显示结束状态
    switch (reason) {
        case 1:
            NSLog(@"正常结束");
            break;
        case 2:
            NSLog(@"用户退出");
            break;
        default:
            NSLog(@"异常结束");
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
