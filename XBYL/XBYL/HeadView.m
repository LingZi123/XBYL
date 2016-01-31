//
//  HeadView.m
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "HeadView.h"
#import "HospitalInfo.h"
#import "PatientInfo.h"

@interface HeadView()
{
    UIButton *_bgButton;
    UILabel *_numLabel;
    UIButton *_selectAllButton;//全选按钮
    BOOL _isSelectAll;
}
@end

@implementation HeadView

+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headIdentifier = @"header";
    
    HeadView *headView = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
    if (headView == nil) {
        headView = [[HeadView alloc] initWithReuseIdentifier:headIdentifier];
    }
    
    return headView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgButton setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
        [bgButton setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        [bgButton setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgButton.imageView.contentMode = UIViewContentModeCenter;
        bgButton.imageView.clipsToBounds = NO;
        bgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        bgButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [bgButton addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        _bgButton = bgButton;
        
        UIButton *selestbtn=[[UIButton alloc]init];
        [selestbtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllButton=selestbtn;
        [self addSubview:selestbtn];
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentLeft;
        numLabel.text=@"全选";
        [self addSubview:numLabel];
        _numLabel = numLabel;
    }
    return self;
}

- (void)headBtnClick
{
    _dataGroup.opened = !_dataGroup.isOpened;
    if ([_delegate respondsToSelector:@selector(clickHeadView)]) {
        [_delegate clickHeadView];
    }
}

-(void)selectAllBtnClick:(UIButton *)sender{
//    _dataGroup.opened=!_dataGroup.isOpened;
    
    if (_isSelectAll) {
        _isSelectAll=NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
    else{
        _isSelectAll=YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        
    }
    for (PatientInfo *patient in _dataGroup.patients) {
        if (patient.isShown!=_isSelectAll) {
            patient.isShown=_isSelectAll;
        }
    }

    if ([_delegate respondsToSelector:@selector(selectAllBtnClick)]) {
        [_delegate selectAllBtnClick];
    }
}

- (void)setDataGroup:(HospitalInfo *)dataGroup
{
    _dataGroup = dataGroup;
    
    [_bgButton setTitle:dataGroup.hosName forState:UIControlStateNormal];
    _bgButton.titleLabel.font=[UIFont systemFontOfSize:14];
    _isSelectAll=YES;
    
    if (_dataGroup) {
        for (PatientInfo *patient in _dataGroup.patients) {
            if (!patient.isShown) {
                _isSelectAll=NO;
                break;
            }
        }
    }
    if (_isSelectAll) {
        [_selectAllButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
    else{
        [_selectAllButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }

    _numLabel.text =@"全选";
//    [NSString stringWithFormat:@"%ld", dataGroup.patients.count];
}

- (void)didMoveToSuperview
{
    _bgButton.imageView.transform = _dataGroup.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame =CGRectMake(0, 0, self.frame.size.width-60-self.frame.size.height, self.frame.size.height);
    _selectAllButton.frame=CGRectMake(self.frame.size.width-50-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
    _numLabel.frame = CGRectMake(self.frame.size.width - 50, 0, 60, self.frame.size.height);
}

@end
