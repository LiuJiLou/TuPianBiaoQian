//
//  addLabelView.h
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/9/22.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addLabelViewDelegate <NSObject>

-(void)clickRemoveLabel:(int)viewTag;
//-(void)clickEditorTitle:(int)viewTag;
-(void)clickLabel:(NSString *)titleStr viewTag:(int)tag;

@end
@interface addLabelView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * borderView;

@property (nonatomic, assign) int viewTag;
@property (nonatomic, weak) id<addLabelViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)setInfo:(NSString *)titleStr;

@end
