//
//  buttonView.h
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/23.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buttonViewClickDelegate <NSObject>

-(void)clickButtonView:(NSInteger)viewTag;

@end

@interface buttonView : UIView
{
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
    UILabel * _annotationlabel;
    UIView * _buttonView;
}

@property (nonatomic, assign) NSInteger viewTag;
@property (nonatomic, weak) id<buttonViewClickDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)setInfo:(NSString *)titleStr annotationStr:(NSString *)anStr iconName:(NSString *)iconName;
@end
