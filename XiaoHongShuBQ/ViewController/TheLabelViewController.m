//
//  TheLabelViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/23.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "TheLabelViewController.h"
#import "compileViewController.h"

@interface TheLabelViewController ()<UITextFieldDelegate>
{
    UITextField * _titleField;
}
@end

@implementation TheLabelViewController

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor purpleColor];
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 30)];
    _titleField.backgroundColor = [UIColor whiteColor];
    _titleField.delegate = self;
    _titleField.clearButtonMode =UITextFieldViewModeWhileEditing;
    _titleField.font = [UIFont systemFontOfSize:15];
    _titleField.returnKeyType = UIReturnKeyDone;
    _titleField.text = _titleStr;
    [self.view addSubview:_titleField];
    
    UIButton * blackButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, SCREEN_HEIGHT-120, 60, 60)];
    blackButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [blackButton setTitle:@"X" forState:(UIControlStateNormal)];
    [blackButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    blackButton.titleLabel.font = [UIFont systemFontOfSize:54];
    [blackButton addTarget:self action:@selector(clickBlackButton:) forControlEvents:(UIControlEventTouchUpInside)];
    blackButton.layer.cornerRadius = 30;
    [self.view addSubview:blackButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField的代理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    注销成为第一响应者；键盘就会消失
        [_titleField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField//区分不同的方法
{
    [_titleField resignFirstResponder];
    NSString * titleStr = [[NSString alloc] init];
    if (textField.text.length >10) {
        
        titleStr = [textField.text substringWithRange:NSMakeRange(0, 10)];
//        titleStr = [textField.text substringToIndex:9];
    }else
        titleStr = textField.text;
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回上一页");

        if (_ViewTag >0) {
            if (![titleStr isEqualToString:@""]) {
                NSDictionary * dic = @{@"viewTag":[NSString stringWithFormat:@"%d",_ViewTag],@"labelStr":titleStr};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyLabel" object:dic];
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteLabel" object:[NSString stringWithFormat:@"%d",_ViewTag]];
            }
        }else{
            if (![titleStr isEqualToString:@""]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:titleStr];
            }

        }
        
    }];
    
    return YES;
}

-(void)clickBlackButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
