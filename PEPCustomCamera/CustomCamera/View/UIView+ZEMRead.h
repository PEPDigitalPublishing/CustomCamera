//
//  UIView+ZEMRead.h
//  PEPRead
//
//  Created by 李沛倬 on 2017/10/11.
//  Copyright © 2017年 PEP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZEMRead)

#pragma mark - IBInspectable Proprety

///可以在xib里面直接设置圆角
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
///可以在xib里面直接设置边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
///可以在xib里面直接设置边线颜色
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

#pragma mark - Proprety
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/**根据响应者链获取当前视图所在的 视图控制器*/
@property (nonatomic, strong, readonly) UIViewController *viewController;
/**根据响应者链获取当前视图所在的 导航控制器*/
@property (nonatomic, strong, readonly) UINavigationController *navigationController;


/**是否允许视图跟随手指移动。默认为false。*/
@property (nonatomic, assign) BOOL allowFollowDraging;
/**是否回弹到原位置。默认为false，需与allowFollowDraging共同使用，单独设置无效果。*/
@property (nonatomic, assign) BOOL springback;


/**设置为true时，当前视图将具备按下缩小，松手回弹的动画效果（会自动将userInteractionEnabled设置为true，无需重复设置），默认为false*/
@property (nonatomic, assign) BOOL allowSpring;


/**设置为true时，当前视图会跟随按压屏幕的力度缩放（需要ForceTouch屏幕支持，会自动将userInteractionEnabled设置为true，无需重复设置），默认为false*/
@property (nonatomic, assign) BOOL      allowForceTouchScale NS_AVAILABLE_IOS(9_0);
/**视图根据按压力度缩放的最大倍数，默认为1.2，需与allowForceTouchScale属性配合使用，单独设置无效*/
@property (nonatomic, assign) CGFloat   maxForceTouchScale   NS_AVAILABLE_IOS(9_0);


#pragma mark - Public Methods
/// 计算并返回传入的rect的中心点坐标
- (CGPoint)getCenterWithRect:(CGRect)rect;
/// 将当前视图按传入的缩放倍数（大于0）相对于原点缩放
- (void)scaleRelativeOriginByFactor:(CGFloat)scaleFactor;
- (void)scaleRelativeOriginByFactor:(CGFloat)scaleFactor animation:(BOOL)allowAnimation;
/// 将当前视图按传入的缩放倍数（大于0）相对于中心点缩放
- (void)scaleRelativeCenterByFactor:(CGFloat)scaleFactor;
- (void)scaleRelativeCenterByFactor:(CGFloat)scaleFactor animation:(BOOL)allowAnimation;


/**
 显示缩放动画

 @param scale 最大缩放倍数，大于1
 */
//- (void)showZoomAnimationWithMaxScale:(CGFloat)scale;
//- (void)showZoomAnimation;


/**
 *  自动根据所属类从同类名XIB中获取并返回当前类对象
 *  默认情况下两个参数均可传nil
 *  如果一个XIB文件中包含多个视图，则默认返回第一个
 */
+ (instancetype)viewFromNibByDefaultClassName:(id)owner option:(NSDictionary*)dic;


@end
