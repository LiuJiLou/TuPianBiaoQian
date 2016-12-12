//
//  buttonView.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/23.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "buttonView.h"

#define selfW self.frame.size.width
#define selfH self.frame.size.height

@implementation buttonView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = selfH/2;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, selfH-10, selfH-10)];
        [_iconImageView setImage:[UIImage imageNamed:@"QQ20160822-0@2x.png"]];
        [self addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+_iconImageView.frame.size.width+10, 5, 100, 15)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_titleLabel];
        
        _annotationlabel = [[UILabel alloc] initWithFrame:CGRectMake(20+_iconImageView.frame.size.width+10, 15+15, 100, 15)];
        _annotationlabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_annotationlabel];
        
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfW, selfH)];
        _buttonView.userInteractionEnabled = YES;
        [self addSubview:_buttonView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButtonView:)];
        [_buttonView addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)clickButtonView:(UITapGestureRecognizer *)tap
{
    NSLog(@"buttonView点击了");
    if (_delegate) {
        [_delegate clickButtonView:_viewTag];
    }
}

-(void)setInfo:(NSString *)titleStr annotationStr:(NSString *)anStr iconName:(NSString *)iconName
{
    [_iconImageView setImage:[UIImage imageNamed:iconName]];
    _titleLabel.text = titleStr;
    _annotationlabel.text = anStr;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
