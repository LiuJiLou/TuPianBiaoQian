//
//  KICropImageView.m
//  Kitalker
//
//  Created by 杨 烽 on 12-8-9.
//
//

#import "KICropImageView.h"

@implementation KICropImageView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [[self scrollView] setFrame:self.bounds];
    [[self maskView] setFrame:self.bounds];
    
    if (CGSizeEqualToSize(_cropSize, CGSizeZero)) {
//        [self setCropSize:CGSizeMake(100, 100)];
        [self setCropSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [[self scrollView] addSubview:_imageView];
    }
    return _imageView;
}

- (KICropImageMaskView *)maskView {
    if (_maskView == nil) {
        _maskView = [[KICropImageMaskView alloc] init];
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [_maskView setUserInteractionEnabled:NO];
        [self addSubview:_maskView];
        [self bringSubviewToFront:_maskView];
    }
    return _maskView;
}

- (void)setImage:(UIImage *)image {
    if (image != _image) {
        _image = nil;
//        _image = [image retain];
    }
    _image = image;
    [[self imageView] setImage:_image];
    
    [self updateZoomScale];
}

- (void)updateZoomScale {
    CGFloat width = _image.size.width;
    CGFloat height = _image.size.height;
//图片原始大小
    [[self imageView] setFrame:CGRectMake(0, 0, width, height)];
    
////根据屏幕宽度高适应屏幕
//    CGFloat proportionW = _image.size.width/SCREEN_WIDTH;
//    CGFloat nowHigh = _image.size.height * proportionW;
//    
//    if (_isNavigation) {
//        
//        CGFloat proportionH = _image.size.height/SCREEN_HEIGHT;
//        if (nowHigh > (SCREEN_HEIGHT - HEIGHT_NAV_STATUS_BAR)) {
//            [[self imageView] setFrame:CGRectMake(0, 0, _image.size.width/proportionH, SCREEN_HEIGHT-HEIGHT_NAV_STATUS_BAR)];
//        }else{
//            [[self imageView] setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*proportionW)];
//        }
//    }else{
//        
//        CGFloat proportionH = _image.size.height/SCREEN_HEIGHT;
//        if (nowHigh > SCREEN_HEIGHT) {
//            [[self imageView] setFrame:CGRectMake(0, 0, _image.size.width/ proportionH, SCREEN_HEIGHT)];
//        }else{
//            [[self imageView] setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*proportionW)];
//        }
//    }
    
    
    CGFloat xScale = _cropSize.width / width;
    CGFloat yScale = _cropSize.height / height;
    
    CGFloat min = MAX(xScale, yScale);
    CGFloat max = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        max = 1.0 / [[UIScreen mainScreen] scale];
    }
    
    if (min > max) {
        min = max;
    }
    
    [[self scrollView] setMinimumZoomScale:min];
    [[self scrollView] setMaximumZoomScale:max + 5.0f];
    
    [[self scrollView] setZoomScale:max animated:YES];
}

- (void)setCropSize:(CGSize)size {
    _cropSize = size;
    [self updateZoomScale];
    
    CGFloat width = _cropSize.width;
    CGFloat height = _cropSize.height;
    
    CGFloat x = (CGRectGetWidth(self.bounds) - width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - height) / 2;

    [[self maskView] setCropSize:_cropSize];
    
    CGFloat top = 0;
    if (_isNavigation) {
        top = y-64;
    }else
        top = y;
    
    CGFloat left = x;
    CGFloat right = CGRectGetWidth(self.bounds)- width - x;
    CGFloat bottom = CGRectGetHeight(self.bounds)- height - y;
    _imageInset = UIEdgeInsetsMake(top, left, bottom, right);
    [[self scrollView] setContentInset:_imageInset];
    
//    [self scrollView].contentSize = CGSizeMake([self imageView].frame.size.width, [self imageView].frame.size.height);
    
    [[self scrollView] setContentOffset:CGPointMake(0, 0)];
}

- (UIImage *)cropImage {
    CGFloat zoomScale = [self scrollView].zoomScale;
    
    CGFloat offsetX = [self scrollView].contentOffset.x;
    CGFloat offsetY = [self scrollView].contentOffset.y;
    CGFloat aX = offsetX>=0 ? offsetX+_imageInset.left : (_imageInset.left - ABS(offsetX));
    CGFloat aY = offsetY>=0 ? offsetY+_imageInset.top : (_imageInset.top - ABS(offsetY));
    
    aX = aX / zoomScale;
    aY = aY / zoomScale;
    
    CGFloat aWidth =  MAX(_cropSize.width / zoomScale, _cropSize.width);
    CGFloat aHeight = MAX(_cropSize.height / zoomScale, _cropSize.height);
    
#ifdef DEBUG
    NSLog(@"%f--%f--%f--%f", aX, aY, aWidth, aHeight);
#endif
    
    UIImage *image = [_image cropImageWithX:aX y:aY width:aWidth height:aHeight];
    
    image = [image resizeToWidth:_cropSize.width height:_cropSize.height];

    return image;
}

#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self imageView];
}


@end

#pragma KISnipImageMaskView

#define kMaskViewBorderWidth 2.0f

@implementation KICropImageMaskView

- (void)setCropSize:(CGSize)size {
    CGFloat x = (CGRectGetWidth(self.bounds) - size.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    _cropRect = CGRectMake(x, y, size.width, size.height);
    
    [self setNeedsDisplay];
}

- (CGSize)cropSize {
    return _cropRect.size;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, .6);
    CGContextFillRect(ctx, self.bounds);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeRectWithWidth(ctx, _cropRect, kMaskViewBorderWidth);
    
    CGContextClearRect(ctx, _cropRect);
}
@end
