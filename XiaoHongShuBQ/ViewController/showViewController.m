//
//  showViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/23.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "showViewController.h"
#import "coordinatesModel.h"
#import "labelProportion.h"
#import "labelview.h"
#import "labelViewModel.h"

#define SELFW self.view.frame.size.width
#define SELFH self.view.frame.size.height

@interface showViewController ()
{
    coordinatesModel * _coodeModel;
    UIImageView * _tuImageView;
    NSMutableArray * _labelArray;
    NSDictionary * _newDic;
    
    CGFloat _tuImageViewX;
    CGFloat _tuImageViewY;
    CGFloat _tuImageViewW;
    CGFloat _tuImageViewH;
}
@end

@implementation showViewController

-(void)loadView
{
    [super loadView];
    self.navigationItem.title = @"显示标签";
    self.view.backgroundColor = [UIColor orangeColor];
    _labelArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _newDic = [[NSDictionary alloc] initWithDictionary:[userDefaultes dictionaryForKey:@"storageData"]];
    
    if (!isEmpty(_newDic)) {
        [self loadNewData];
        [self createUI];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)loadNewData{
    
    _coodeModel = [[coordinatesModel alloc] init];
    
    NSData * _decodedImageData = [[NSData alloc] initWithBase64EncodedString:_newDic[@"image"] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
    
    _coodeModel.imageName = _newDic[@"imageName"];
    _coodeModel.image = _decodedImage;
    
    _coodeModel.real_imageViewX = [_newDic[@"real_imageViewX"] floatValue];
    _coodeModel.real_imageViewY = [_newDic[@"real_imageViewY"] floatValue];
    _coodeModel.real_imageViewW = [_newDic[@"real_imageViewW"] floatValue];
    _coodeModel.real_imageViewH = [_newDic[@"real_imageViewH"] floatValue];
    
    _coodeModel.label_Array = _newDic[@"label_Array"];
    
    for (int i=0; i<_coodeModel.label_Array.count; i++) {
        labelViewModel * model = [[labelViewModel alloc] init];
        NSDictionary * dic = _coodeModel.label_Array[i];
        model.label_text = dic[@"label_text"];
        model.label_X = [dic[@"label_x"] floatValue];
        model.label_Y = [dic[@"label_y"] floatValue];
        
        [_labelArray addObject:model];
    }
}

-(void)createUI{
    _tuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 300, 300)];
    
//    UIImage * _tuimage = [UIImage imageNamed:_coodeModel.imageName];
    UIImage * _tuimage = _coodeModel.image;
    [_tuImageView setImage:_coodeModel.image];
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
    
    for (labelViewModel * model in _labelArray) {
        
        CGFloat title_x = [labelProportion getLabelXImageViewX:_tuImageViewX imageViewY:_tuImageViewY imageViewWide:_tuImageViewW imageViewHigh:_tuImageViewH realImageWide:_coodeModel.real_imageViewW realLabeX:model.label_X];
        CGFloat title_y = [labelProportion getLabelYImageViewX:_tuImageViewX imageViewY:_tuImageViewY imageViewWide:_tuImageViewW imageViewHigh:_tuImageViewH realImageHigh:_coodeModel.real_imageViewH realLabeY:model.label_Y];
        
        labelView * _titleLableView = [[labelView alloc] initWithFrame:CGRectMake(title_x, title_y, 100, 20)];
        [_titleLableView setInfo:model.label_text];
        [_tuImageView addSubview:_titleLableView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
