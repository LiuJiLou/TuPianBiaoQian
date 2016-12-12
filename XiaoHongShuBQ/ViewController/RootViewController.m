//
//  RootViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 2016/12/9.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "RootViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface RootViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    [imageView setImage:[UIImage imageNamed:@"20161207.gif"]];
//    [self.view addSubview:imageView];
    
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"20161207" ofType:@"gif"];
//    NSData *gifData = [NSData dataWithContentsOfFile:path];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
////    webView.backgroundColor = [UIColor redColor];
//    webView.scalesPageToFit = YES;
//    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [self.view addSubview:webView];
    
    
    
    //3. animationView
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"1.jpg"],
                         [UIImage imageNamed:@"2.jpg"],
                         [UIImage imageNamed:@"3.jpg"],
                         [UIImage imageNamed:@"4.jpg"],
                         [UIImage imageNamed:@"5.jpg"],
                         [UIImage imageNamed:@"6.jpg"],
                         [UIImage imageNamed:@"7.jpg"],
                         [UIImage imageNamed:@"8.jpg"],nil];
    gifImageView.animationImages = gifArray; //动画图片数组
    gifImageView.animationDuration = 1; //执行一次完整动画所需的时长
    gifImageView.animationRepeatCount = 1900;  //动画重复次数
    [gifImageView startAnimating];
    [self.view addSubview:gifImageView];

    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-90, 100, 40)];
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    button.layer.borderWidth = 1.0f;
    [button setTitle:@"立即使用" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(didClickButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}

-(void)didClickButton
{
    AppDelegate * delegat = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegat initRootViewController];
}


-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc]init];
        [_moviePlayer.view setFrame:self.view.bounds];
        //设置自动播放
        [_moviePlayer setShouldAutoplay:NO];
        //设置源类型 因为新特性一般都是播放本地的小视频 所以设置源类型为file
        _moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        //取消控制视图 如：播放暂停等
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:_moviePlayer.view];
        //监听播放完成
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinsihed) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    return _moviePlayer;
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
