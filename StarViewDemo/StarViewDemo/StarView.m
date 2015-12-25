//
//  StarView.m
//  StarViewDemo
//
//  Created by coderyi on 15/12/25.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "StarView.h"
@interface StarView ()
/**
 *  评分背景 imageView
 */
@property (nonatomic, strong) UIImageView *scoreBgImageView;
/**
 *  评分分数 imageView
 */
@property (nonatomic, strong) UIImageView *scoreImageView;
@end
@implementation StarView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scoreBgImageView];
        [self addSubview:self.scoreImageView];
        CGRect viewFrame=self.bounds;
        self.scoreBgImageView.frame = viewFrame;
        //0.0-5.0
        float scoreValue =  4.5;
        _scoreImageView.frame = CGRectMake(0, 0, viewFrame.size.width*(scoreValue/5.0), viewFrame.size.height);
        
        

    }
    return self;
}


- (UIImageView *)scoreBgImageView{
    if (!_scoreBgImageView) {
        _scoreBgImageView = [[UIImageView alloc] init];
        _scoreBgImageView.image = [UIImage imageNamed:@"driver_score_gray"];
    }
    return _scoreBgImageView;
}
- (UIImageView *)scoreImageView{
    if (!_scoreImageView) {
        _scoreImageView = [[UIImageView alloc] init];
        _scoreImageView.image = [UIImage imageNamed:@"driver_score_light"];
        _scoreImageView.clipsToBounds      = YES;
        _scoreImageView.contentMode        = UIViewContentModeBottomLeft;
    }
    return _scoreImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
