//
//  UIView+ZEMRead.m
//  PEPRead
//
//  Created by 李沛倬 on 2017/10/11.
//  Copyright © 2017年 PEP. All rights reserved.
//

#import "UIView+ZEMRead.h"
#import <objc/runtime.h>

static CGFloat const animationDuration = 0.1;

@implementation UIView (ZEMRead)

#pragma mark - IBInspectable
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = true;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

+ (instancetype)viewFromNibByDefaultClassName:(id)owner option:(NSDictionary*)dic
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:dic] firstObject];
}

#pragma mark - Position
- (void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setLeft:(CGFloat)left {
    CGRect newFrame = self.frame;
    newFrame.origin.x = left;
    self.frame = newFrame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setTop:(CGFloat)top {
    CGRect newFrame = self.frame;
    newFrame.origin.y = top;
    self.frame = newFrame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect newFrame = self.frame;
    newFrame.origin.y = bottom - self.height;
    self.frame = newFrame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.height;
}

- (void)setRight:(CGFloat)right {
    CGRect newFrame = self.frame;
    newFrame.origin.x = right - self.left;
    self.frame = newFrame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.width;
}

- (void)setSize:(CGSize)size {
    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame = newFrame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint newCenter = self.center;
    newCenter.x = centerX;
    self.center = newCenter;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint newCenter = self.center;
    newCenter.y = centerY;
    self.center = newCenter;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGPoint)getCenterWithRect:(CGRect)rect {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

- (void)scaleRelativeOriginByFactor:(CGFloat)scaleFactor {
    [self scaleRelativeOriginByFactor:scaleFactor animation:false];
}

- (void)scaleRelativeOriginByFactor:(CGFloat)scaleFactor animation:(BOOL)allowAnimation {
    if (scaleFactor <= 0) { return; }
    
    CGRect newFrame = self.frame;
    newFrame.size.width  *= scaleFactor;
    newFrame.size.height *= scaleFactor;
    [UIView animateWithDuration:(allowAnimation ? 0.2 : 0) animations:^{
        self.frame = newFrame;
    }];
}

- (void)scaleRelativeCenterByFactor:(CGFloat)scaleFactor {
    [self scaleRelativeCenterByFactor:scaleFactor animation:false];
}

- (void)scaleRelativeCenterByFactor:(CGFloat)scaleFactor animation:(BOOL)allowAnimation {
    if (scaleFactor <= 0) { return; }
    
    CGFloat insetWidth = (1-scaleFactor) * self.width;
    CGFloat insetHeight = (1-scaleFactor) * self.height;
    
    CGRect newFrame = CGRectInset(self.frame, insetWidth/2, insetHeight/2);
    [UIView animateWithDuration:(allowAnimation ? 0.2 : 0) animations:^{
        self.frame = newFrame;
    }];
}

#pragma mark - Responder Chain
- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

- (UINavigationController *)navigationController {
    return self.viewController.navigationController;
}

#pragma mark - Associated Proprety
- (void)setAllowFollowDraging:(BOOL)allowFollowDraging {
    self.userInteractionEnabled = true;
    objc_setAssociatedObject(self, @selector(allowFollowDraging), @(allowFollowDraging), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)allowFollowDraging {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(allowFollowDraging));
    return num.boolValue;
}

- (void)setSpringback:(BOOL)springback {
    objc_setAssociatedObject(self, @selector(springback), @(springback), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)springback {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(springback));
    return num.boolValue;
}

- (BOOL)allowSpring {
    NSNumber *num = (NSNumber *)objc_getAssociatedObject(self, @selector(allowSpring));
    return num.boolValue;
}

- (void)setAllowSpring:(BOOL)allowSpring {
    objc_setAssociatedObject(self, @selector(allowSpring), @(allowSpring), OBJC_ASSOCIATION_ASSIGN);
    if (allowSpring == true) {
        self.userInteractionEnabled = allowSpring;
    }
}

- (BOOL)allowForceTouchScale {
    NSNumber *num = objc_getAssociatedObject(self, @selector(allowForceTouchScale));
    return num.boolValue;
}

- (void)setAllowForceTouchScale:(BOOL)allowForceTouchScale {
    objc_setAssociatedObject(self, @selector(allowForceTouchScale), @(allowForceTouchScale), OBJC_ASSOCIATION_ASSIGN);
    if (allowForceTouchScale == true) {
        self.userInteractionEnabled = allowForceTouchScale;
    }
}

- (CGFloat)maxForceTouchScale {
    NSNumber *num = objc_getAssociatedObject(self, @selector(maxForceTouchScale));
    return num != nil ? num.floatValue : 1.2;
}

- (void)setMaxForceTouchScale:(CGFloat)maxForceTouchScale {
    objc_setAssociatedObject(self, @selector(maxForceTouchScale), @(maxForceTouchScale), OBJC_ASSOCIATION_ASSIGN);
}

- (void)showZoomAnimation {
    [self showZoomAnimationWithMaxScale:0];
    
}
- (void)showZoomAnimationWithMaxScale:(CGFloat)scale {
    [self.layer removeAllAnimations];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1);
    animation.toValue = @(MAX(1, scale));
    animation.duration = 0.2;
    animation.autoreverses = YES;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
    
}




#pragma mark - Touch Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.allowSpring == true) {
        CGFloat scale = 0.97;
        [UIView animateWithDuration:animationDuration animations:^{
            self.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    if (self.allowFollowDraging == true) {
        CGPoint currentPoint = [touch locationInView:self];
        CGPoint lastPoint = [touch previousLocationInView:self];
        CGPoint offsetPoint = CGPointMake(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y);
        
        self.transform = CGAffineTransformTranslate(self.transform, offsetPoint.x, offsetPoint.y);
    }
    
    if (@available(iOS 9.0, *)) {
        if (self.allowForceTouchScale == true) {
            CGFloat scale = touch.force / touch.maximumPossibleForce * (self.maxForceTouchScale - 1) + 1;
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.allowFollowDraging == true && self.springback == true) {
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
    
    if (self.allowSpring) {
        CGFloat scale = 1.03;
        [UIView animateWithDuration:animationDuration animations:^{
            self.transform = CGAffineTransformMakeScale(scale, scale);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    
    if (@available(iOS 9.0, *)) {
        if (self.allowForceTouchScale == true) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    if (self.allowFollowDraging == true && self.springback == true) {
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
    
    if (@available(iOS 9.0, *)) {
        if (self.allowForceTouchScale == true) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }
    } else {
        // Fallback on earlier versions
    }
    
}

@end












