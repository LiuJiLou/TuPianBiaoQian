//
//  coordinatesModel.h
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/27.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface coordinatesModel : NSObject

@property (nonatomic, copy) NSString * imageName;
@property (nonatomic, strong) UIImage * image;

@property (nonatomic, assign) CGFloat real_imageViewX;
@property (nonatomic, assign) CGFloat real_imageViewY;
@property (nonatomic, assign) CGFloat real_imageViewW;
@property (nonatomic, assign) CGFloat real_imageViewH;

@property(nonatomic,strong) NSArray * label_Array;

//@property (nonatomic, assign) CGFloat label1_x;
//@property (nonatomic, assign) CGFloat label1_y;
//@property (nonatomic, assign) CGFloat label2_x;
//@property (nonatomic, assign) CGFloat label2_y;
//@property (nonatomic, assign) CGFloat label3_x;
//@property (nonatomic, assign) CGFloat label3_y;
//
//@property (nonatomic, copy) NSString * label1_text;
//@property (nonatomic, copy) NSString * label2_text;
//@property (nonatomic, copy) NSString * label3_text;


@end
