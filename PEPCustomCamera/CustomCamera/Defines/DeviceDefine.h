//
//  DeviceDefine.h
//  HeTianHelp_User
//
//  Created by 张二猛 on 2019/5/15.
//  Copyright © 2019 张二猛. All rights reserved.
//

#ifndef DeviceDefine_h
#define DeviceDefine_h


#define KScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kMinScreenWidth MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

#define kwindow [UIApplication sharedApplication].keyWindow

#define kFrameScale          (KScreenWidth/375.0)
#define kFrameHScale          (KScreenHeight/667.0)

#define JH_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define  JH_StatusBarHeight      (JH_iPhoneX ? 44.f : 20.f)
#define  JH_NavigationBarHeight  44.f
#define  JH_TabbarHeight         (JH_iPhoneX ? (49.f+34.f) : 49.f)
#define  JH_TabbarSafeBottomMargin         (JH_iPhoneX ? 34.f : 0.f)
#define  JH_StatusBarAndNavigationBarHeight  (JH_iPhoneX ? 88.f : 64.f)

#define kgetFrameScaleFloat(x)  (x*kFrameScale)                           //(x)

//#define WeakSelf __weak typeof(self) weakSelf = self;

#define DeleteNull(value) ([value isKindOfClass:[NSNull class]] || !value) ?@"":value

#define USERINFOMANAGER [ZEMUserInfoManager shareInstance]
#define USERDEFAULT [NSUserDefaults standardUserDefaults]

#define ZEMLocalString(key) NSLocalizedString(key, nil)

#define kIsiPhone [[UIDevice currentDevice].model containsString:@"iPhone"]

#endif /* DeviceDefine_h */
