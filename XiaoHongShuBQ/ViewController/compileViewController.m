//
//  compileViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/23.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "compileViewController.h"
#import "labelView.h"
#import "addLabelView.h"
#import "buttonView.h"
#import "SunViewController.h"
#import "TheLabelViewController.h"
#import "Masonry.h"
#import "coordinatesModel.h"
#import "labelViewModel.h"
#import "EditorViewController.h"
#import "ViewController.h"

#define SELFW self.view.frame.size.width
#define SELFH self.view.frame.size.height

@interface compileViewController ()<addLabelViewDelegate,labelViewDelegate,buttonViewClickDelegate,UIScrollViewDelegate>
{
    addLabelView * _TitleView;
    UIImageView * _tuImageView;
    
    UIView * _blackView;
    UIView * _backgroundView;
    buttonView * _shareButtonView;
    buttonView * _addButtonView;
    
    CGFloat _titleViewX;
    CGFloat _titleViewY;
    CGFloat _labelX;
    CGFloat _labelY;
    
    CGFloat _tuImageViewX;
    CGFloat _tuImageViewY;
    CGFloat _tuImageViewW;
    CGFloat _tuImageViewH;
    NSMutableArray * _storageDataArray;
}

@end

@implementation compileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)loadView
{
    [super loadView];
    self.navigationItem.title = @"添加标签";
    
//    self.navigationController.hidesBarsOnTap = YES;
    [self setNavigationView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _storageDataArray = [[NSMutableArray alloc] init];
    
//    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(secongPage)];
//    
//    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
//创建标签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickButton:) name:@"update" object:nil];
//修改标签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickModifyLabel:) name:@"ModifyLabel" object:nil];
//删除标签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDeleteLabel:) name:@"deleteLabel" object:nil];
    
    _tuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 300, 300)];

    if (_dataArray.count>0) {
        _tuimage = _dataArray[0];
        
    }else{
        _imageName = @"1001.jpg";
        _tuimage = [UIImage imageNamed:_imageName];
    }
    
    [_tuImageView setImage:_tuimage];
    CGFloat imageW = _tuimage.size.width;
    CGFloat imageH = _tuimage.size.height;
    CGFloat tuW = SELFW;
    CGFloat tuH = tuW * imageH / imageW;
    CGFloat SelfViewH = SCREEN_HEIGHT - HEIGHT_NAV_STATUS_BAR;
    if (tuH >SelfViewH) {
        _tuImageView.frame = CGRectMake((SELFW-SelfViewH*imageW/imageH)/2, HEIGHT_NAV_STATUS_BAR, SelfViewH*imageW/imageH, SelfViewH);
        
        _tuImageViewX = (SELFW-SelfViewH*imageW/imageH)/2;
        _tuImageViewY = HEIGHT_NAV_STATUS_BAR;
        _tuImageViewW = SelfViewH*imageW/imageH;
        _tuImageViewH = SelfViewH;
    }else{
        _tuImageView.frame = CGRectMake(0, (SELFH-tuH)/2, SELFW, tuH);
        _tuImageViewX = 0;
        _tuImageViewY = (SELFH-tuH)/2;
        _tuImageViewW = SELFW;
        _tuImageViewH = tuH;
    }
    
    _tuImageView.userInteractionEnabled = YES;
    _tuImageView.clipsToBounds = YES;
    [self.view addSubview:_tuImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageViewLabel:)];
    [_tuImageView addGestureRecognizer:tap];
    
    
//遮挡
    _blackView = [[UIView alloc] initWithFrame:self.view.frame];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4f;
    _blackView.hidden = YES;
    [self.view addSubview:_blackView];
    
    _backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    //    _blackView.backgroundColor = [UIColor clearColor];
    _backgroundView.hidden = YES;
    [self.view addSubview:_backgroundView];
    
    UITapGestureRecognizer * tapCancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancelBackgroundView)];
    [_backgroundView addGestureRecognizer:tapCancel];

    
    _shareButtonView = [[buttonView alloc] initWithFrame:CGRectMake((SELFW-190)/2, SELFH/2-55, 170, 50)];
    _shareButtonView.viewTag = 101;
    _shareButtonView.delegate = self;
    [_shareButtonView setInfo:@"晒货" annotationStr:@"介绍/关联商品" iconName:@"icon_rili.png"];
    [_backgroundView addSubview:_shareButtonView];
    
    _addButtonView = [[buttonView alloc] initWithFrame:CGRectMake((SELFW-190)/2, SELFH/2+5, 170, 50)];
    _addButtonView.viewTag = 102;
    _addButtonView.delegate = self;
    [_addButtonView setInfo:@"标签" annotationStr:@"让更多人看到" iconName:@"icon_edit_h.png"];
    [_backgroundView addSubview:_addButtonView];
    
}


-(void)setNavigationView
{
    UIView * navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, HEIGHT_NAV_BAR)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:navigationView];
    
    //返回按钮
    UIButton * blockButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
//    [blockButton setTitle:@"<" forState:(UIControlStateNormal)];
    [blockButton setImage:[UIImage imageNamed:@"icon_left"] forState:(UIControlStateNormal)];
    [blockButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [blockButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationView addSubview:blockButton];
    
    //滚动视图
    UIScrollView * imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 2, SCREEN_WIDTH-100, 40)];
    imageScrollView.showsHorizontalScrollIndicator=YES;
    imageScrollView.showsHorizontalScrollIndicator=YES;
    imageScrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (int i = 0; i<_dataArray.count; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45*i, 2, 40, 40)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image =_dataArray[i];
        imageView.tag = i;
        [imageScrollView addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        [imageView addGestureRecognizer:tap];
    }
    [navigationView addSubview:imageScrollView];
    
//下一步
    UIButton * nextStepButton = [[UIButton alloc] init];
    [nextStepButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    [nextStepButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [nextStepButton sizeToFit];
    [nextStepButton addTarget:self action:@selector(clickRightButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationView addSubview:nextStepButton];
    
    [nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.height.mas_equalTo(@30);
        make.rightMargin.mas_equalTo(@-10);
        make.top.mas_equalTo(@7);
    }];

}

-(void)clickLeftButton:(UIButton *)button
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)clickRightButton:(UIButton *)button
{
    
}

#pragma mark - 调出标签、晒货标签
-(void)addImageViewLabel:(UITapGestureRecognizer *)tap
{
    _labelX = _titleViewX;
    _labelY = _titleViewY;
    int count = 0;
    for(id tmpView in [_tuImageView subviews])
    {
        if([tmpView isKindOfClass:[addLabelView class]])
        {
            count++;
        }
    }
    
    if (count < 3) {
        _backgroundView.hidden = NO;
        _blackView.hidden = NO;
    }else{
        [self showOnlyTextDialog:@"标签太多了哦~"];
    }
}

-(void)tapCancelBackgroundView
{
    _backgroundView.hidden = YES;
    _blackView.hidden = YES;
}

//获取屏幕点击位置
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    _titleViewX = touchPoint.x;
    _titleViewY = touchPoint.y;
    
    NSLog(@"%f==%f",touchPoint.x,touchPoint.y);

}

#pragma mark - 通知的调用方法
-(void)clickButton:(NSNotification *)notification
{
    static int i = 0;
    i++;
    
    CGFloat titleX = _labelX - _tuImageViewX-2.5;
    CGFloat titleY = _labelY - _tuImageViewY-10;
    _TitleView = [[addLabelView alloc] initWithFrame:CGRectMake(titleX, titleY, [self calculateTitleWide:notification.object], 20)];
    [_TitleView setInfo:notification.object];
    
    _TitleView.tag = i;
    _TitleView.viewTag = i;
    _TitleView.delegate = self;
    [_tuImageView addSubview:_TitleView];
    
    //一、注册拖动动画
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
    [_TitleView addGestureRecognizer:panGestureRecognizer];
    
    labelViewModel * _labelModel = [[labelViewModel alloc] init];
    _labelModel.label_X = titleX;
    _labelModel.label_Y = titleY;
    _labelModel.view_tag = i;
    _labelModel.label_text = notification.object;
    [_storageDataArray addObject:_labelModel];
}

-(void)clickModifyLabel:(NSNotification *)notification
{
    NSDictionary * dataDic = notification.object;
    if (![self isEqual:dataDic]) {
        [self clickEditorTitle:dataDic[@"labelStr"] viewTag:[dataDic[@"viewTag"] intValue]];
    }
}

-(void)clickDeleteLabel:(NSNotification *)notification
{
    [self removeView:[notification.object intValue]];
}


-(void)clickLabel:(NSString *)titleStr viewTag:(int)tag
{
    TheLabelViewController * theLabelVC = [[TheLabelViewController alloc] init];
    theLabelVC.titleStr = titleStr;
    theLabelVC.ViewTag = tag;
    [self presentViewController:theLabelVC animated:YES completion:nil];
}

#pragma mark - 删除标签
-(void)removeView:(int)tag
{
    for(id tmpView in [_tuImageView subviews])
    {
        //找到要删除的子视图的对象
        if([tmpView isKindOfClass:[addLabelView class]])
        {
            addLabelView * view = (addLabelView *)tmpView;
            if (tag == 0) {
                [tmpView removeFromSuperview];
            }else if (view.tag == tag){
                [view removeFromSuperview];
                
                NSMutableArray * newArr = [[NSMutableArray alloc] init];
                for (labelViewModel * model in _storageDataArray) {
                    if (model.view_tag != tag) {
                        [newArr addObject:model];
                    }
                }
                [_storageDataArray removeAllObjects];
                _storageDataArray = newArr;
                break;
            }
        }
    }
}

#pragma mark - 修改标签
-(void)clickEditorTitle:(NSString *)titleStr viewTag:(int)viewTag
{
    for(id tmpView in [_tuImageView subviews])
    {
        //找到要修改的子视图的对象
        if([tmpView isKindOfClass:[addLabelView class]])
        {
            addLabelView * view = (addLabelView *)tmpView;
            if (view.tag == viewTag){
                
                view.titleLabel.text = titleStr;
                [view.titleLabel sizeToFit];
                view.borderView.frame = CGRectMake(15, 0, view.titleLabel.frame.size.width+10, view.frame.size.height);
                [_TitleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake([self calculateTitleWide:titleStr], view.frame.size.height));
                }];
                
//替换数组内容
                for (int i=0 ; i<_storageDataArray.count ; i++) {
                    labelViewModel * model = _storageDataArray[i];
                    if (model.view_tag == viewTag) {
                        model.label_text = titleStr;
                        [_storageDataArray replaceObjectAtIndex:i withObject:model];
                    }
                }
                
                break;
            }
        }
    }
}

-(CGFloat)calculateTitleWide:(NSString *)titleStr
{
    UILabel * labelW = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    labelW.font = [UIFont systemFontOfSize:15];
    labelW.text = titleStr;
    [labelW sizeToFit];
    return 15+labelW.frame.size.width+10;
}

#pragma mark - ButtonView 按钮代理
-(void)clickButtonView:(NSInteger)viewTag
{
    NSLog(@"clickButtonView%d",viewTag);
    if (viewTag == 101) {
        
        SunViewController * sunVC = [[SunViewController alloc] init];
        [self.navigationController pushViewController:sunVC animated:YES];
        [self tapCancelBackgroundView];
    }else if (viewTag == 102){
        
        TheLabelViewController * theLabelVC = [[TheLabelViewController alloc] init];
        [self presentViewController:theLabelVC animated:YES completion:nil];
        [self tapCancelBackgroundView];
    }
    
}

-(void)secongPage
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:_imageName forKey:@"imageName"];
    NSData *data = UIImageJPEGRepresentation(_tuimage, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [dic setValue:encodedImageStr forKey:@"image"];
    
    [dic setValue:[NSString stringWithFormat:@"%f",_tuImageViewX] forKey:@"real_imageViewX"];
    [dic setValue:[NSString stringWithFormat:@"%f",_tuImageViewY] forKey:@"real_imageViewY"];
    [dic setValue:[NSString stringWithFormat:@"%f",_tuImageViewW] forKey:@"real_imageViewW"];
    [dic setValue:[NSString stringWithFormat:@"%f",_tuImageViewH] forKey:@"real_imageViewH"];
    
    NSMutableArray * labelArr = [[NSMutableArray alloc] init];
    
        for (int i=0; i<_storageDataArray.count; i++) {
            labelViewModel * model = _storageDataArray[i];
//            if (i==0) {
    
            NSMutableDictionary * labelDic = [[NSMutableDictionary alloc] init];
            [labelDic setValue:model.label_text forKey:@"label_text"];
            [labelDic setValue:[NSString stringWithFormat:@"%f",model.label_X] forKey:@"label_x"];
            [labelDic setValue:[NSString stringWithFormat:@"%f",model.label_Y]  forKey:@"label_y"];
            
            [labelArr addObject:labelDic];
        }
    [dic setValue:(NSArray *)labelArr forKey:@"label_Array"];
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:(NSDictionary *)dic forKey:@"storageData"];
    
    EditorViewController * editprVC = [[EditorViewController alloc] init];
    [self.navigationController pushViewController:editprVC animated:YES];
}

#pragma mark - 拖动动画限制，防止出界。
- (void) doHandlePanAction:(UIPanGestureRecognizer *)paramSender{
    
    //    CGPoint point = [paramSender translationInView:self.view];
    CGPoint point = [paramSender translationInView:_tuImageView];
    
    //    NSLog(@"X:%f;Y:%f",point.x,point.y);
    //    NSLog(@"View X:%f;View Y:%f",paramSender.view.center.x + point.x,paramSender.view.center.y + point.y);
    
    CGFloat imageLeftX = _tuImageView.center.x - _tuImageView.frame.size.width/2;
    CGFloat imageRightX = _tuImageView.center.x + _tuImageView.frame.size.width/2;
    
    CGFloat imageTopY = _tuImageView.center.y - _tuImageView.frame.size.height/2;
    CGFloat imageBottomY = _tuImageView.center.y + _tuImageView.frame.size.height/2;
    
    //    NSLog(@"imageLeftX:%f",imageLeftX);
    //    NSLog(@"imageRightX:%f",imageRightX);
    //    NSLog(@"imageTopY:%f",imageTopY);
    //    NSLog(@"imageBottomY:%f",imageBottomY);
    
    CGFloat viewLeftX = paramSender.view.center.x + point.x - _TitleView.frame.size.width/2 + imageLeftX;
    CGFloat viewRightX = paramSender.view.center.x + point.x + _TitleView.frame.size.width/2 + imageLeftX;
    
    CGFloat viewTopY = paramSender.view.center.y + point.y - _TitleView.frame.size.height/2 + imageTopY;
    CGFloat viewBottomY = paramSender.view.center.y + point.y + _TitleView.frame.size.height/2 + imageTopY;
    
    //        NSLog(@"viewLeftX:%f",viewLeftX);
    //        NSLog(@"viewRightX:%f",viewRightX);
    //    NSLog(@"viewTopY:%f",viewTopY);
    //        NSLog(@"viewBottomY:%f",viewBottomY);
    
    
    if (viewLeftX < imageLeftX) {
        if (viewTopY < imageTopY) {
            paramSender.view.center = CGPointMake(_TitleView.frame.size.width/2, _TitleView.frame.size.height/2);
            
        }else if (viewBottomY > imageBottomY){
            
            paramSender.view.center = CGPointMake(_TitleView.frame.size.width/2, imageBottomY - imageTopY - _TitleView.frame.size.height/2);
        }else{
            
            paramSender.view.center = CGPointMake(_TitleView.frame.size.width/2, paramSender.view.center.y + point.y);
        }
    }else if (viewRightX > imageRightX){
        
        if (viewTopY < imageTopY) {
            
            paramSender.view.center = CGPointMake(imageRightX - imageLeftX - _TitleView.frame.size.width/2, _TitleView.frame.size.height/2);
            
        }else if (viewBottomY >imageBottomY){
            
            paramSender.view.center = CGPointMake(imageRightX - imageLeftX - _TitleView.frame.size.width/2, imageBottomY - imageTopY - _TitleView.frame.size.height/2);
        }else{
            
            paramSender.view.center = CGPointMake(imageRightX - imageLeftX - _TitleView.frame.size.width/2, paramSender.view.center.y + point.y);
        }
    }else if (viewTopY < imageTopY){
        
        paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, _TitleView.frame.size.height/2);
    }else if (viewBottomY >imageBottomY){
        
        paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, imageBottomY - imageTopY - _TitleView.frame.size.height/2);
    }else{
        paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    }
    
    //    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    [paramSender setTranslation:CGPointMake(0, 0) inView:_tuImageView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
