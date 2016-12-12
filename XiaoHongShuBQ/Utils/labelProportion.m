//
//  labelProportion.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/27.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "labelProportion.h"

@implementation labelProportion

+(CGFloat)getLabelXImageViewX:(CGFloat)imageViewX imageViewY:(CGFloat)imageViewY imageViewWide:(CGFloat)imageViewW imageViewHigh:(CGFloat)imageViewH realImageWide:(CGFloat)realImageW realLabeX:(CGFloat)labelX
{
    CGFloat newLabelX = 0.0f;
    CGFloat proportion = imageViewW/realImageW;
    newLabelX = labelX*proportion;
    
    return newLabelX;
}

+(CGFloat)getLabelYImageViewX:(CGFloat)imageViewX imageViewY:(CGFloat)imageViewY imageViewWide:(CGFloat)imageViewW imageViewHigh:(CGFloat)imageViewH realImageHigh:(CGFloat)realImageH realLabeY:(CGFloat)labelY
{
    CGFloat newLabelY = 0.0f;
    CGFloat proportion = imageViewH/realImageH;
    newLabelY = labelY*proportion;
    
    return newLabelY;
}

@end
