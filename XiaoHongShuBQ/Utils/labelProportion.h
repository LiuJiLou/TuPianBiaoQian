//
//  labelProportion.h
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/27.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface labelProportion : NSObject
/**
 *  返回显示标签的x轴坐标
 *
 *  @param imageViewX imageViewX description
 *  @param imageViewY imageViewY description
 *  @param imageViewW imageViewW description
 *  @param imageViewH imageViewH description
 *  @param realImageW realImageW 原图片宽
 *  @param labelX     labelX 原label X轴坐标
 *
 *  @return 现在的标签x轴坐标
 */
+(CGFloat)getLabelXImageViewX:(CGFloat)imageViewX imageViewY:(CGFloat)imageViewY imageViewWide:(CGFloat)imageViewW imageViewHigh:(CGFloat)imageViewH realImageWide:(CGFloat)realImageW realLabeX:(CGFloat)labelX;

/**
 *  返回显示标签的y轴坐标
 *
 *  @param imageViewX imageViewX description
 *  @param imageViewY imageViewY description
 *  @param imageViewW imageViewW description
 *  @param imageViewH imageViewH description
 *  @param realImageW realImageW 原图片宽
 *  @param labelY     labelY 原label Y轴坐标
 *
 *  @return 现在的标签Y轴坐标
 */
+(CGFloat)getLabelYImageViewX:(CGFloat)imageViewX imageViewY:(CGFloat)imageViewY imageViewWide:(CGFloat)imageViewW imageViewHigh:(CGFloat)imageViewH realImageHigh:(CGFloat)realImageH realLabeY:(CGFloat)labelY;

@end
