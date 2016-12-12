//
//  tailoringViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/29.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "tailoringViewController.h"
#import "compileViewController.h"

@interface tailoringViewController ()<UIScrollViewDelegate>
{
    NSMutableArray * _imageData;
}

@end

@implementation tailoringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = [NSString stringWithFormat:@"裁切(1/%lu)",(unsigned long)_dataArray.count];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    _imageData = [[NSMutableArray alloc] init];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _cropImageView = [[KICropImageView alloc] initWithFrame:self.view.bounds];
    _cropImageView = [[KICropImageView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAV_STATUS_BAR, SCREEN_WIDTH, SCREEN_HEIGHT-HEIGHT_NAV_STATUS_BAR)];
    _cropImageView.isNavigation = YES;
    [_cropImageView setCropSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
    
//    [_cropImageView setImage:[UIImage imageNamed:@"1003.jpg"]];
    if (_dataArray.count>0) {
        UIImage * image = _dataArray[0];
        [_cropImageView setImage:image];
    }
    
    [self.view addSubview:_cropImageView];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(secongPage)];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setFrame:CGRectMake(80, 31, 150, 31)];
//    [btn setTitle:@"crop and save" forState:UIControlStateNormal];
//    
//    [self.view addSubview:btn];
//    
//    [btn addTarget:self action:@selector(aa) forControlEvents:UIControlEventTouchUpInside];
}

////保存到本地
//- (void)aa {
//    NSData *data = UIImagePNGRepresentation([_cropImageView cropImage]);
//    
//    [data writeToFile:[NSString stringWithFormat:@"%@/Documents/test.png", NSHomeDirectory()] atomically:YES];
//}

-(void)secongPage
{
    static int i=1;
    
    if (![self isEqual:[_cropImageView cropImage]]) {
        [_imageData addObject:[_cropImageView cropImage]];
    }
    
    if (i<_dataArray.count) {
        UIImage * image = _dataArray[i];
        [_cropImageView setImage:image];
        
    }else{
        
        compileViewController * comVC = [[compileViewController alloc] init];
        comVC.tuimage = [_cropImageView cropImage];
        comVC.dataArray = _imageData;
//        comVC.dataArray = _dataArray;
        [self.navigationController pushViewController:comVC animated:YES];
    }
    
    
    i++;
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
