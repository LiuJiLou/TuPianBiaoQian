//
//  addLabelView.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/22.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "addLabelView.h"
#import "Masonry.h"

@implementation addLabelView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * yuanView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2-5, 10 ,10)];
        yuanView.center = CGPointMake(5, self.frame.size.height/2);
        yuanView.backgroundColor = [UIColor whiteColor];
        yuanView.layer.cornerRadius = 5;
        [self addSubview:yuanView];
        
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-15, self.frame.size.height)];
        _borderView.backgroundColor = [UIColor whiteColor];
        _borderView.layer.cornerRadius = self.frame.size.height/2;
        [self addSubview:_borderView];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-15, self.frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.clipsToBounds = YES;
        [_borderView addSubview:_titleLabel];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitle:)];
        [_borderView addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)setInfo:(NSString *)titleStr
{
    _titleLabel.text = titleStr;
    [_titleLabel sizeToFit];
    _borderView.frame = CGRectMake(15, 0, _titleLabel.frame.size.width+10, self.frame.size.height);
}

-(void)clickTitle:(UITapGestureRecognizer *)tap
{
    NSLog(@"addLabelView点击了title");
    if (_delegate) {
        [_delegate clickLabel:_titleLabel.text viewTag:_viewTag];
    }
}

-(void)clickRemoveView
{
    NSLog(@"点击了删除");
    if (_delegate) {
        [_delegate clickRemoveLabel:_viewTag];
    }
}


@end
