//
//  labelView.h
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/22.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol labelViewDelegate <NSObject>

-(void)clickLabelViewTag:(int)tag;

@end

@interface labelView : UIView
{
    CALayer *_layer;
    CAAnimationGroup *_animaTionGroup;
    CADisplayLink *_disPlayLink;
    NSTimer * _timer;
    UILabel * _titleLabel;
    UIView * _borderView;
    UIButton * _removeButton;
    NSString * _title;
}

@property (nonatomic, assign) int viewTag;
@property (nonatomic, weak) id<labelViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)setInfo:(NSString *)titleStr;
@end
