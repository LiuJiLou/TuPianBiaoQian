//
//  ZZPhotoPickerViewController.m
//  ZZFramework
//
//  Created by Yuan on 15/7/7.
//  Copyright (c) 2015年 zzl. All rights reserved.
//



#import "ZZPhotoPickerViewController.h"
#import "ZZPhotoDatas.h"
#import "ZZPhotoPickerCell.h"
#import "ZZBrowserPickerViewController.h"
#import "ZZPhotoHud.h"
@interface ZZPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZZBrowserPickerDelegate>

@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSMutableArray *selectArray;

@property (strong, nonatomic) UICollectionView *picsCollection;

@property (strong, nonatomic) UIButton *selectBtn;
@property (assign, nonatomic) BOOL isSelect;

@property (strong, nonatomic) UIBarButtonItem *backBtn;
@property (strong, nonatomic) UIBarButtonItem *cancelBtn;

@property (strong, nonatomic) UIButton *doneBtn;                       //完成按钮
@property (strong, nonatomic) UIButton *previewBtn;                    //预览按钮

@property (strong, nonatomic) UILabel *totalNumLabel;
@property (strong, nonatomic) ZZPhotoDatas *datas;
@property (strong, nonatomic) ZZBrowserPickerViewController *browserController;
@property (strong, nonatomic) UILabel *numSelectLabel;
@end

@implementation ZZPhotoPickerViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma SETUP backButtonUI Method
- (UIBarButtonItem *)backBtn{
    if (!_backBtn) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _backBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }
    return _backBtn;
}

#pragma SETUP cancelButtonUI Method
- (UIBarButtonItem *)cancelBtn{
    if (!_cancelBtn) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }
    return _cancelBtn;
}

#pragma mark SETUP doneButtonUI Method

-(UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZZ_VW - 60, 0, 50, 44)];
        [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_doneBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _doneBtn;
}

#pragma merk SETUP previewButtonUI Method

-(UIButton *)previewBtn{
    if (!_previewBtn) {
        _previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 44)];
        [_previewBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_previewBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _previewBtn;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 完成然后回调
-(void)done{

    if ([self.selectArray count] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [ZZPhotoHud showActiveHud];
        NSMutableArray *photos = [NSMutableArray array];
        for (int i = 0; i < self.selectArray.count; i++) {
            id asset = [self.selectArray objectAtIndex:i];
            [self.datas GetImageObject:asset complection:^(UIImage *photo ,BOOL isDegradedResult) {
                if (isDegradedResult) {
                    return;
                }
                if (photo){
                    [photos addObject:photo];
                }
                if (photos.count < self.selectArray.count){
                    return;
                }
                if (self.PhotoResult) {
                    self.PhotoResult(photos);
                }
                
                [ZZPhotoHud hideActiveHud];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
 
    }
}

//预览按钮，弹出图片浏览器
-(void)preview{
    
    if (self.selectArray.count == 0) {
        [self showPhotoPickerAlertView:@"提醒" message:@"您还没有选中图片，不需要预览"];
    }else{
        self.browserController = [[ZZBrowserPickerViewController alloc]init];
        self.browserController.delegate = self;
        [self.browserController reloadData];
        [self.browserController showIn:self animation:ShowAnimationOfPresent];
    }

}


#pragma Declaration Array
-(NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

-(NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

#pragma 懒加载图片数据
-(ZZPhotoDatas *)datas{
    if (!_datas) {
        _datas = [[ZZPhotoDatas alloc]init];
        _datas.type = self.imageType;
    }
    return _datas;
}

#pragma 总共多少张照片Label

-(UILabel *)totalNumLabel{
    if (!_totalNumLabel) {
        _totalNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ZZ_VW, 20)];
        _totalNumLabel.textColor = [UIColor blackColor];
        _totalNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalNumLabel;
}

-(void)setUpTabbar
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = UIColorFromRGBA(0xe0  ,0x33, 0x3e,0.8);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.doneBtn];
    [view addSubview:self.previewBtn];
    [self.view addSubview:view];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZZ_VW, 1)];
    viewLine.backgroundColor = ZZ_RGB(230, 230, 230);
    [view addSubview:viewLine];
    
    NSLayoutConstraint *tab_bottom = [NSLayoutConstraint constraintWithItem:_picsCollection attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ZZ_VW];
    
    NSLayoutConstraint *tab_height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    
    [self.view addConstraints:@[tab_bottom,tab_width,tab_height]];
    
    
}

-(void)setupCollectionViewUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    flowLayout.minimumInteritemSpacing = 1.0;//item 之间的行的距离
    flowLayout.minimumLineSpacing = 1.0;//item 之间竖的距离
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    //        self.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _picsCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_picsCollection registerClass:[ZZPhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
    [_picsCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    flowLayout.footerReferenceSize = CGSizeMake(ZZ_VW, 70);
    _picsCollection.delegate = self;
    _picsCollection.dataSource = self;
    _picsCollection.backgroundColor = [UIColor whiteColor];
    [_picsCollection setUserInteractionEnabled:YES];
    _picsCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_picsCollection];
    [_picsCollection reloadData];
    
    
    NSLayoutConstraint *pic_top = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *pic_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeBottom multiplier:1 constant:44.0f];
    
    NSLayoutConstraint *pic_left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *pic_right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[pic_top,pic_bottom,pic_left,pic_right]];
    
}

- (void)initInterUI
{
   // self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backBtn;
    self.navigationItem.rightBarButtonItem = self.cancelBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInterUI];
    
    [self loadPhotoData];
    // 更新UI
    [self setupCollectionViewUI];
    //创建底部工具栏
    [self setUpTabbar];
    

}

-(void)loadPhotoData
{
    if (_isAlubSeclect == YES) {
        
        self.photoArray = [self.datas GetPhotoAssets:_fetch];
        [self refreshTotalNumLabelData:_photoArray.count];

    }else{
        self.photoArray = [self.datas GetPhotoAssets:[self.datas GetCameraRollFetchResul]];
        [self refreshTotalNumLabelData:_photoArray.count];
    }
}

-(void)refreshTotalNumLabelData:(NSInteger)totalNum
{
    self.totalNumLabel.text = [NSString stringWithFormat:Total_Pic_Num,(long)totalNum];
}


#pragma mark 关键位置，选中的在数组中添加，取消的从数组中减少
-(void)selectPicBtn:(UIButton *)button
{
    NSInteger index = button.tag;
    if (button.selected == NO) {
        [self shakeToShow:button];
        if (self.selectArray.count + 1 > _selectNum) {
            [self showSelectPhotoAlertView:_selectNum];
        }else{
            [self.selectArray addObject:[self.photoArray objectAtIndex:index]];
            [button setImage:Pic_Btn_Selected forState:UIControlStateNormal];
            button.selected = YES;
        }
    }else{
        [self shakeToShow:button];
        [self.selectArray removeObject:[self.photoArray objectAtIndex:index]];
        [button setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
        button.selected = NO;
    }
}

#pragma mark 列表中按钮点击动画效果

- (void) shakeToShow:(UIButton*)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}


#pragma UICollectionView --- Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    ZZPhotoPickerCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    
    
    photoCell.selectBtn.tag = indexPath.row;
    [photoCell.selectBtn addTarget:self action:@selector(selectPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [photoCell loadPhotoData:[self.photoArray objectAtIndex:indexPath.row]];
    [photoCell selectBtnStage:self.selectArray existence:[self.photoArray objectAtIndex:indexPath.row]];
    
    return photoCell;
}
#pragma UICollectionView --- Delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *footerView = [[UICollectionReusableView alloc]init];
    footerView.backgroundColor = [UIColor redColor];
    if (kind == UICollectionElementKindSectionFooter){
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    }

    [footerView addSubview:self.totalNumLabel];
    return footerView;
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     *   此功能未完成，待后期完善。
     */
//    [self.browserDataArray removeAllObjects];
//    [self.browserDataArray addObjectsFromArray:self.photoArray];
//    self.browserController.indexPath = indexPath;
//    [self.browserController showIn:self animation:ShowAnimationOfPresent];
//    [self.browserController reloadData];
}


#pragma mark --- ZZBrowserPickerDelegate
-(NSInteger)zzbrowserPickerPhotoNum:(ZZBrowserPickerViewController *)controller
{
    return self.selectArray.count;
}

-(NSArray *)zzbrowserPickerPhotoContent:(ZZBrowserPickerViewController *)controller
{
    return self.selectArray;
}

-(void)showSelectPhotoAlertView:(NSInteger)photoNumOfMax
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:Alert_Max_Selected,(long)photoNumOfMax]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showPhotoPickerAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
