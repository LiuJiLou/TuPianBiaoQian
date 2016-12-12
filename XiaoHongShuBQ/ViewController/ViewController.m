//
//  ViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/21.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "ViewController.h"
#import "compileViewController.h"
#import "showViewController.h"
#import "tailoringViewController.h"
#import "EvaluateViewController.h"
#import "MP4ViewController.h"
#import "PositioningViewController.h"
#import "SunViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _myTableView;
    NSArray * _dataArr;
}

@end

@implementation ViewController

-(void)loadView
{
    [super loadView];
    
//    NSArray * arr = @[@[@"1001",@"124*220"],@[@"1002",@"124*220"],@[@"1003",@"124*220"],@[@"1004",@"124*220"],@[@"1005",@"1440*2560"],@[@"1006",@"124*220"]];
    
    self.navigationItem.title = @"列表";
    _dataArr = @[@"添加标签",@"显示标签",@"视频播放",@"获取当前位置"];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    UIView * v = [[UIView alloc] initWithFrame:CGRectZero];
    [_myTableView setTableFooterView:v];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tabelView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * compileCell = @"compileCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:compileCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:compileCell];
    }
    
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        compileViewController * compoleVC = [[compileViewController alloc] init];
//        tailoringViewController * compoleVC = [[tailoringViewController alloc] init];
        EvaluateViewController * compoleVC = [[EvaluateViewController alloc] init];
        
        [self.navigationController pushViewController:compoleVC animated:YES];
    }else if(indexPath.row == 1){
        showViewController * showVC = [[showViewController alloc] init];
        [self.navigationController pushViewController:showVC animated:YES];
    }else if (indexPath.row == 2){
        MP4ViewController *mp4VC = [[MP4ViewController alloc] init];
        [self.navigationController pushViewController:mp4VC animated:YES];
    }else if(indexPath.row == 3){
        PositioningViewController * positioningVC = [[PositioningViewController alloc] init];
        [self.navigationController pushViewController:positioningVC animated:YES];
    }
//    SunViewController * sunVC = [[SunViewController alloc] init];
//    [self.navigationController pushViewController:sunVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
