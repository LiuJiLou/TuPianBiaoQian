//
//  SunViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/23.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "SunViewController.h"

@interface SunViewController ()

@end

@implementation SunViewController

//-(void)loadView{
//    [super loadView];
//    self.navigationItem.title = @"晒货";
//    self.view.backgroundColor = [UIColor yellowColor];
//    
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


__weak NSString * string_weak_ = nil;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self print];
    
//    NSString * string = nil;
    NSString * string = [NSString stringWithFormat:@"leichunfeng"];
//    @autoreleasepool {
//        NSString * string = [NSString stringWithFormat:@"leichunfeng"];
        string_weak_ = string;
//    }
    NSLog(@"1、string:%@",string_weak_);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"2、string:%@",string_weak_);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"3、string:%@",string_weak_);
}

-(void)print
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSLog(@"A");
    });
    NSLog(@"B");
    dispatch_queue_t queuetmp = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0&1);
    dispatch_sync(queuetmp, ^{
        NSLog(@"C");
    });
    
    dispatch_async(queuetmp, ^{
        NSLog(@"D");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSLog(@"E");
    });
    
    [self performSelector:@selector(method) withObject:nil afterDelay:0.0];
    NSLog(@"F");
}

-(void)method
{
    NSLog(@"G");
}
//BCFDAEG
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
