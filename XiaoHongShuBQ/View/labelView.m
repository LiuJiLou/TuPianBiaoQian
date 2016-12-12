//
//  labelView.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/22.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "labelView.h"

@implementation labelView
-(id)initWithFrame:(CGRect)frame
{self = [super initWithFrame:frame];
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
//        _titleLabel.layer.cornerRadius = 5;
        _titleLabel.clipsToBounds = YES;
//        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_borderView addSubview:_titleLabel];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitle:)];
        [_borderView addGestureRecognizer:tap];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerBegin) userInfo:nil repeats:YES];
        
    }
    return self;
    
}

-(void)setInfo:(NSString *)titleStr
{
    _title = titleStr;
    _titleLabel.text = titleStr;
    [_titleLabel sizeToFit];
    _borderView.frame = CGRectMake(15, 0, _titleLabel.frame.size.width+10, self.frame.size.height);
}

- (void)startAnimation
{
    CALayer *layer = [[CALayer alloc] init];
    //    layer.cornerRadius = [UIScreen mainScreen].bounds.size.width/2;
    //半径
    layer.cornerRadius = 30.0;
    //    layer.frame = CGRectMake(0, 0, layer.cornerRadius * 2, layer.cornerRadius * 2);
    layer.frame = CGRectMake(-self.frame.size.width/4, -self.layer.frame.size.height, layer.cornerRadius * 2, layer.cornerRadius * 2);
    
    //    layer.position = TitleView.layer.position;
    //    UIColor *color = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
    //移动的颜色
    UIColor * color = [UIColor whiteColor];
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    
    
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    _animaTionGroup = [CAAnimationGroup animation];
    _animaTionGroup.delegate = self;
    _animaTionGroup.duration = 2;
    _animaTionGroup.removedOnCompletion = YES;
    _animaTionGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = 2;
    
    CAKeyframeAnimation *opencityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opencityAnimation.duration = 2;
    //渐变透明度
    opencityAnimation.values = @[@1,@0.5,@0];
    //渐变大小
    opencityAnimation.keyTimes = @[@0,@0.5,@1];
    opencityAnimation.removedOnCompletion = YES;
    
    NSArray *animations = @[scaleAnimation,opencityAnimation];
    _animaTionGroup.animations = animations;
    [layer addAnimation:_animaTionGroup forKey:nil];
    
    [self performSelector:@selector(removeLayer:) withObject:layer afterDelay:1.5];
    
    [self removeTitleView];
}

- (void)removeLayer:(CALayer *)layer
{
    [layer removeFromSuperlayer];
}

-(void)removeTitleView
{
    [self.layer removeAllAnimations];
    [_disPlayLink invalidate];
    _disPlayLink = nil;
}

- (void)timerBegin
{
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(delayAnimation)];
    _disPlayLink.frameInterval = 40;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)delayAnimation
{
    [self startAnimation];
}

-(void)clickTitle:(UITapGestureRecognizer *)tap
{
    NSLog(@"labelView 点击了title");
//    if (_delegate) {
//        [_delegate clickLabel:_title viewTag:_viewTag];
//    }
}


@end
