//
//  FMHourGlassView.m
//  HourGlassView
//
//  Created by Mr.Liu on 16/12/8.
//  Copyright © 2016年 Personal. All rights reserved.
//

#import "FMHourGlassView.h"
#define Hour_Glass_Width 22.0f
#define Hour_Glass_Duration 3.0f
#define Default_Color [UIColor grayColor]

@interface FMHourGlassView ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, weak)   UIView *containerView;
@property (nonatomic, retain) CALayer *containerLayer;
@property (nonatomic, retain) CAShapeLayer *topLayer;
@property (nonatomic, retain) CAShapeLayer *bottomLayer;
@property (nonatomic, retain) CAShapeLayer *lineLayer;
@property (nonatomic, retain) CAKeyframeAnimation *topAnimation;
@property (nonatomic, retain) CAKeyframeAnimation *bottomAnimation;
@property (nonatomic, retain) CAKeyframeAnimation *lineAnimation;
@property (nonatomic, retain) CAKeyframeAnimation *containerAnimation;
@end

@implementation FMHourGlassView

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        
        // 背景
        _containerView = view;
        
        [self initCommon];
        [self initContainer];
        [self initTop];
        [self initBottom];
        [self initLine];
        [self initAnimation];
        [self startAnimation];
    }
    return self;
}
- (void)initCommon {
    
    self.frame = CGRectMake(0, 0, _containerView.bounds.size.width, _containerView.bounds.size.height);
    self.backgroundColor = [UIColor clearColor];
    
    // sqrtf:求平方根
    _width = sqrtf(Hour_Glass_Width * Hour_Glass_Width + Hour_Glass_Width * Hour_Glass_Width);
    _height = sqrtf(Hour_Glass_Width * Hour_Glass_Width);
    
    // 宽是高的2倍
    //    _height = sqrtf(Hour_Glass_Width*Hour_Glass_Width - ( (_width/2.0f) * (_width/2.0f) ) );
    
    //    NSLog(@"宽：%f 高：%f",_width,_height);
}
- (void)initContainer {
    
    // 绘制沙漏背景
    _containerLayer = [CALayer layer];
    _containerLayer.backgroundColor = [UIColor clearColor].CGColor;
    _containerLayer.frame = CGRectMake(0, 0, _width, _height*2);
    _containerLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _containerLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self.layer addSublayer:_containerLayer];
}
#pragma mark ----------顶部倒三角----------
- (void)initTop {
    
    // 画▽
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 开始点
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(_width, 0)];
    [path addLineToPoint:CGPointMake(_width/2.0f, _height)];
    // 结束点
    [path addLineToPoint:CGPointMake(0, 0)];
    // 关闭路径
    [path closePath];
    
    //▽填充
    _topLayer = [CAShapeLayer layer];
    // 位置 大小
    _topLayer.frame = CGRectMake(0, 0, _width, _height);
    // 填充路径
    _topLayer.path = path.CGPath;
    // 填充颜色
    _topLayer.fillColor = Default_Color.CGColor;
    // 边线粗细
    _topLayer.lineWidth = 0.0f;
    // 锚点，从左上角开始顺时针数，四个点的锚点是：(0,0),(1,0),(1,1),(0,1)
    _topLayer.anchorPoint = CGPointMake(0.5f, 1);// ▽的尖角
    // 位置
    _topLayer.position = CGPointMake(_width/2, _height);
    // 添加到SuperLayer
    [_containerLayer addSublayer:_topLayer];
    
    
    // 画▽边框
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(0, 0)];
    [borderPath addLineToPoint:CGPointMake(_width, 0)];
    [borderPath addLineToPoint:CGPointMake(_width/2, _height)];
    [borderPath addLineToPoint:CGPointMake(0, 0)];
    [borderPath closePath];
    // ▽边框填充
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, _width, _height);
    borderLayer.path = borderPath.CGPath;
    borderPath.lineWidth = 1.0f;
    borderLayer.strokeColor = Default_Color.CGColor;//边框颜色
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    [_containerLayer addSublayer:borderLayer];
}
#pragma mark ----------底部三角----------
- (void)initBottom {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 画△
    [path moveToPoint:CGPointMake(_width/2.0f, 0)];
    [path addLineToPoint:CGPointMake(_width, _height)];
    [path addLineToPoint:CGPointMake(0, _height)];
    [path addLineToPoint:CGPointMake(_width/2.0f, 0)];
    
    [path closePath];
    // △填充
    _bottomLayer = [CAShapeLayer layer];
    _bottomLayer.frame = CGRectMake(0, _height, _width, _height);
    _bottomLayer.path = path.CGPath;
    _bottomLayer.lineWidth = 0.0f;
    _bottomLayer.fillColor = Default_Color.CGColor;
    _bottomLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
    _bottomLayer.position = CGPointMake(_width/2.0f, _height*2.0f);// △底线中间点
    _bottomLayer.transform = CATransform3DMakeScale(0, 0, 0);
    
    [_containerLayer addSublayer:_bottomLayer];
    
    // △边框
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(0, _height*2)];
    [borderPath addLineToPoint:CGPointMake(_width, _height*2)];
    [borderPath addLineToPoint:CGPointMake(_width/2, _height)];
    [borderPath addLineToPoint:CGPointMake(0, _height*2)];
    [borderPath closePath];
    // △边框填充
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, _width, _height);
    borderLayer.path = borderPath.CGPath;
    borderPath.lineWidth = 1.0f;
    borderLayer.strokeColor = Default_Color.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [_containerLayer addSublayer:borderLayer];
    
}
#pragma mark ----------中间竖线----------
- (void)initLine {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_width/2.0f, 0)];
    [path addLineToPoint:CGPointMake(_width/2.0f, _height)];
    
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.frame = CGRectMake(0, _height, _width, _height);
    _lineLayer.path = path.CGPath;
    _lineLayer.strokeColor = Default_Color.CGColor;
    // 路径开始/结束的地方占总路径的百分比
    _lineLayer.strokeStart = 0;
    _lineLayer.strokeEnd = 1;
    _lineLayer.lineWidth = 1.0f;
    _lineLayer.lineJoin = kCALineJoinMiter;
    // 虚线，@1,@1是指画1个长度，空1个长度...这样循环
    _lineLayer.lineDashPattern = [NSArray arrayWithObjects:@1,@1,nil];
    
    [_containerLayer addSublayer:_lineLayer];
    
}

#pragma mark ----------动画----------
- (void)initAnimation {
    
    // 顶部动画  scale：比例
    _topAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    _topAnimation.duration = Hour_Glass_Duration;
    // HUGE_VALF：最大次数
    _topAnimation.repeatCount = HUGE_VALF;
    _topAnimation.keyTimes = @[@0.0f,@0.9f,@1.0f];
    _topAnimation.values = @[@1.0f,@0.0f,@0.0f];
    
    // 底部动画
    _bottomAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    _bottomAnimation.duration = Hour_Glass_Duration;
    _bottomAnimation.repeatCount = HUGE_VALF;
    _bottomAnimation.keyTimes = @[@0.1f,@0.9f,@1.0f];
    _bottomAnimation.values = @[@0.0f,@1.0f,@1.0f];
    
    // 中间竖线动画 strokeEnd:路径终点
    _lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    _lineAnimation.duration = Hour_Glass_Duration;
    _lineAnimation.repeatCount = HUGE_VAL;
    _lineAnimation.keyTimes = @[@0.0f,@0.1f,@0.9f,@1.0f];
    _lineAnimation.values = @[@0.0f,@1.0f,@1.0f,@1.0f];
    
    // 整个沙漏 旋转
    _containerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 匀速旋转
    _containerAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :0.5 :0.5 :0.5];
    _containerAnimation.duration = Hour_Glass_Duration;
    _containerAnimation.repeatCount = HUGE_VALF;
    // 0.9:0; 1.0:M_PI
    _containerAnimation.keyTimes = @[@0.9f,@1.0f];
    _containerAnimation.values = @[[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI]];
}
- (void)startAnimation {
    
    // 添加动画
    [_topLayer addAnimation:_topAnimation forKey:@"ta"];
    [_bottomLayer addAnimation:_bottomAnimation forKey:@"ba"];
    [_lineLayer addAnimation:_lineAnimation forKey:@"la"];
    [_containerLayer addAnimation:_containerAnimation forKey:@"ca"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end