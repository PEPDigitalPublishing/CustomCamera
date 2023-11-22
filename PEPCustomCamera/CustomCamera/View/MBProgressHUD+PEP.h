//
//  MBProgressHUD+PEP.h
//  PEPDigitalTextBook
//
//  Created by PEP on 2017/5/11.
//  Copyright © 2017年 凌小惯. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (PEP)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

+ (MBProgressHUD *)showLoading:(UIView *)view title:(NSString *)title;
+(MBProgressHUD *)showLoading:(UIView *)view;

// 附加
+ (void)showNormalText:(NSString *)text;
+ (void)showNormalText:(NSString *)text toview:(UIView *)view;

@end
