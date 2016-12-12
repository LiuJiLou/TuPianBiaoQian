//
//  EvaluateViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/30.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "EvaluateViewController.h"
#import <CTAssetsPickerController.h>
#import "tailoringViewController.h"
#import "VPImageCropperViewController.h"
#import "compileViewController.h"

@interface EvaluateViewController ()<CTAssetsPickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,VPImageCropperDelegate>
{
    NSMutableArray  *_dataArray;
    UIImagePickerController *_imagePicker;
    UIScrollView * _myScrollView;
}
@end

@implementation EvaluateViewController

-(void)loadView
{
    [super loadView];
    self.navigationItem.title = @"选取照片";
    _dataArray = [[NSMutableArray alloc] init];
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAV_STATUS_BAR, SCREEN_WIDTH, SCREEN_HEIGHT-HEIGHT_NAV_STATUS_BAR)];
    _myScrollView.showsHorizontalScrollIndicator=YES;
    _myScrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
     _myScrollView.pagingEnabled = YES;
    
    [self.view addSubview:_myScrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self didClickPhoto];
}

//跳转到照片选择
-(void)jumpToPhotoPicker
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.showsNumberOfAssets = NO;
//    picker.title = @"Pick photos";
    picker.title = @"选择照片";
    picker.assetsFilter = [ALAssetsFilter allPhotos]; // Only pick photos
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma -mark CTAssetsPickerControllerDelegate
//完成选择
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *photoSectionArray = _dataArray;
    //	[photoSectionArray removeAllObjects];
    
    for (ALAsset *alAsset in assets) {
        ALAssetRepresentation *representation = alAsset.defaultRepresentation;
        
        UIImage *fullResolutionImage =
        [UIImage imageWithCGImage:representation.fullScreenImage
                            scale:1.0f
                      orientation:(UIImageOrientation)representation.orientation];
        
        [photoSectionArray addObject:fullResolutionImage];
    }
    
    [self upDataScroll];
}

//选择图片
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    // Allow 10 assets to be picked
    NSMutableArray *photoSectionArray = _dataArray;
    if (photoSectionArray.count + picker.selectedAssets.count>9) {
        [self showOnlyTextDialog:@"最多可选择10张照片"];
        return NO;
    }
    return (picker.selectedAssets.count < 10);
}


#pragma mark -OrderEvalutePhotoDelegate 照相机
-(void)didClickPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
    
    //	[self jumpToPhotoPicker];
}

#pragma mark - ActionSheet delegate
//选择拍照还是使用相册中图片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag ==100) {
        if (buttonIndex==0) {
            
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            _imagePicker.allowsEditing = YES;
            
            [self presentViewController:_imagePicker animated:YES completion:^(void){
                
            }];
        }else if(buttonIndex ==1){
            
            [self jumpToPhotoPicker];
            
        }else{
            
        }
    }
}

//相册、相机的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//    [imageData writeToFile:[[FileUtil getUserTempDir] stringByAppendingPathComponent:@"avatar.png"] atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 保存图片到相册中
    SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    
    
    NSMutableArray *photoSectionArray = _dataArray;
//    [photoSectionArray removeAllObjects];
    if (photoSectionArray.count>10) {
        [self showOnlyTextDialog:@"最多可选择10张照片"];
    }else
        [photoSectionArray addObject:image];
}


// 保存图片到相册后，调用的相关方法，查看是否保存成功
- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
        
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

-(void)upDataScroll
{
//    _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_dataArray.count, SCREEN_HEIGHT-HEIGHT_NAV_STATUS_BAR);
//    for (int i = 0; i<_dataArray.count; i++) {
//        
//        UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH , SCREEN_HEIGHT-HEIGHT_NAV_STATUS_BAR)];
//        imgV.contentMode = UIViewContentModeScaleAspectFit;
//        imgV.image =_dataArray[i];
//        [_myScrollView addSubview:imgV];
//    }
    
//    tailoringViewController * tailoringVC = [[tailoringViewController alloc] init];
//    tailoringVC.dataArray = _dataArray;
//    [self.navigationController pushViewController:tailoringVC animated:YES];
    
    if (_dataArray.count >0) {
        UIImage *portraitImg = _dataArray[0];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
//        [self presentViewController:imgEditorVC animated:YES completion:^{
//            // TO DO
//        }];
        [self.navigationController pushViewController:imgEditorVC animated:YES];
    }
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < SCREEN_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = SCREEN_WIDTH;
        btWidth = sourceImage.size.width * (SCREEN_WIDTH / sourceImage.size.height);
    } else {
        btWidth = SCREEN_WIDTH;
        btHeight = sourceImage.size.height * (SCREEN_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark VPImageCropperDelegate
//OK
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    NSMutableArray * _imageData = [[NSMutableArray alloc] init];
    [_imageData addObject:editedImage];
    compileViewController * comVC = [[compileViewController alloc] init];
    comVC.tuimage = editedImage;
    comVC.dataArray = _imageData;
    //        comVC.dataArray = _dataArray;
    [self.navigationController pushViewController:comVC animated:YES];
//    self.portraitImageView.image = editedImage;
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//        // TO DO
//    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
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
