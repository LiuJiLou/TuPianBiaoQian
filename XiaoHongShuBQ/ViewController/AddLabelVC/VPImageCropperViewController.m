//
//  VPImageCropperViewController.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "VPImageCropperViewController.h"

#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface VPImageCropperViewController ()
{
    NSMutableArray * _imageData;
    NSInteger rotation;
}

@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;

@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect latestFrame;

@property (nonatomic, strong) UIView * selfView;

@end

@implementation VPImageCropperViewController

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"剪切";
        _imageData = [[NSMutableArray alloc] init];
        self.cropFrame = cropFrame;
        self.limitRatio = limitRatio;
        self.originalImage = originalImage;
        self.navigationController.hidesBarsOnTap = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(secongPage)];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self initView];
    [self initControlBtn];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (void)initView {
    
    _selfView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_selfView];
    
    //如果该图片大于2M，会自动旋转90度；否则不旋转
    self.originalImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1 orientation:UIImageOrientationUp];
    
    self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
//    [self.showImgView setMultipleTouchEnabled:YES];
//    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setImage:self.originalImage];
//    [self.showImgView setUserInteractionEnabled:YES];
//    [self.showImgView setMultipleTouchEnabled:YES];
    
    // scale to fit the screen
    CGFloat oriWidth = self.cropFrame.size.width;
    CGFloat oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);
    
    NSLog(@"height : %f",self.originalImage.size.height);
    NSLog(@"width : %f",self.originalImage.size.width);
    
    CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;
    self.showImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.showImgView.frame = self.oldFrame;
    
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
    
    [self addGestureRecognizers];
    [_selfView addSubview:self.showImgView];
    
    self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.overlayView.alpha = .5f;
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.userInteractionEnabled = NO;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_selfView addSubview:self.overlayView];
    
    self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
    self.ratioView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.ratioView.layer.borderWidth = 1.0f;
    self.ratioView.autoresizingMask = UIViewAutoresizingNone;
    [_selfView addSubview:self.ratioView];
    
    [self overlayClipping];
}

//下一步
-(void)secongPage
{
    
}

- (void)initControlBtn {
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0f, 100, 50)];
    cancelBtn.backgroundColor = [UIColor blackColor];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cancelBtn.titleLabel setNumberOfLines:0];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_selfView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, self.view.frame.size.height - 50.0f, 100, 50)];
    confirmBtn.backgroundColor = [UIColor blackColor];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [confirmBtn.titleLabel setNumberOfLines:0];
    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [_selfView addSubview:confirmBtn];
    
    UIButton *confirmBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 120.0f, 100, 50)];
    confirmBtn1.backgroundColor = [UIColor blackColor];
    confirmBtn1.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn1 setTitle:@"<" forState:UIControlStateNormal];
    [confirmBtn1.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn1.titleLabel setTextAlignment:NSTextAlignmentCenter];
    confirmBtn1.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn1.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [confirmBtn1.titleLabel setNumberOfLines:0];
    [confirmBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [confirmBtn1 addTarget:self action:@selector(confirm1:) forControlEvents:UIControlEventTouchUpInside];
    [_selfView addSubview:confirmBtn1];
    
    UIButton *confirmBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, self.view.frame.size.height - 120.0f, 100, 50)];
    confirmBtn2.backgroundColor = [UIColor blackColor];
    confirmBtn2.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn2 setTitle:@">" forState:UIControlStateNormal];
    [confirmBtn2.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn2.titleLabel setTextAlignment:NSTextAlignmentCenter];
    confirmBtn2.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn2.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [confirmBtn2.titleLabel setNumberOfLines:0];
    [confirmBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [confirmBtn2 addTarget:self action:@selector(confirm2:) forControlEvents:UIControlEventTouchUpInside];
    [_selfView addSubview:confirmBtn2];
}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}

//OK
- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropper:self didFinished:[self getSubImage]];
    }
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.ratioView.frame.origin.x,
                                        self.overlayView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
                                        0,
                                        self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
                                        self.overlayView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.overlayView.frame.size.width,
                                        self.ratioView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
                                        self.overlayView.frame.size.width,
                                        self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

// register all gestures
- (void) addGestureRecognizers
{
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
        CGFloat newW = self.originalImage.size.width;
        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.originalImage.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

-(void)confirm1:(UIButton *)button
{
    [self setRotationAnimated:1];
    
    
}

-(void)confirm2:(UIButton *)button
{
    [self setRotationAnimated:2];
}

- (void)setRotationAnimated:(NSInteger)animated
{
    if (!isEmpty(_selfView)) {
        [_selfView removeFromSuperview];
        
    //        self.originalImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1 orientation:UIImageOrientationUp];
        UIImage * aImage = self.originalImage;
        self.originalImage = [self rotateImage:aImage animated:animated];
        [self initView];
        [self initControlBtn];
    }
}

-(UIImage *)rotateImage:(UIImage *)aImage animated:(NSInteger)animated
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
//    UIImageOrientation orient = aImage.imageOrientation;
    
//    switch(orient)
    switch(animated)
    {
//        case UIImageOrientationUp: //EXIF = 1
//            transform = CGAffineTransformIdentity;
//            break;
//        case UIImageOrientationUpMirrored: //EXIF = 2
//            transform = CGAffineTransformMakeTranslation(width, 0.0);
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            break;
//        case UIImageOrientationDown: //EXIF = 3
//            transform = CGAffineTransformMakeTranslation(width, height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//        case UIImageOrientationDownMirrored: //EXIF = 4
//            transform = CGAffineTransformMakeTranslation(0.0, height);
//            transform = CGAffineTransformScale(transform, 1.0, -1.0);
//            break;
//        case UIImageOrientationLeftMirrored: //EXIF = 5
//            boundHeight = bounds.size.height;
//            bounds.size.height = bounds.size.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransformMakeTranslation(height, width);
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//            break;
//        case UIImageOrientationLeft: //EXIF = 6
        case 1:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
//        case UIImageOrientationRightMirrored: //EXIF = 7
//            boundHeight = bounds.size.height;
//            bounds.size.height = bounds.size.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransformMakeScale(-1.0, 1.0);
//            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//            break;
//        case UIImageOrientationRight: //EXIF = 8
        case 2:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
//        default:
//            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
//    }
//    else {
//        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
//        CGContextTranslateCTM(context, 0, -height);
//    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}


@end
