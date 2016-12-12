//
//  tailoringViewController.h
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/29.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "KICropImageView.h"

@interface tailoringViewController : BasicViewController
{
    KICropImageView *_cropImageView;
}
@property (nonatomic, copy) NSArray * dataArray;

@end
