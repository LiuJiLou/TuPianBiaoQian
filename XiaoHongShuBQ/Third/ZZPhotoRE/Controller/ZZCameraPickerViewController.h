//
//  ZZCameraPickerViewController.h
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface ZZCameraPickerViewController : UIViewController

@property (assign, nonatomic) BOOL isSavelocal;

@property (assign, nonatomic) NSInteger takePhotoOfMax;
@property (assign, nonatomic) ZZImageType imageType;

@property (strong, nonatomic) void (^CameraResult)(id responseObject);

@end
