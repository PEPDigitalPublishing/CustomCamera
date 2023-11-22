//
//  ColorDefine.h
//  HeTianHelp_User
//
//  Created by 张二猛 on 2019/5/15.
//  Copyright © 2019 张二猛. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h


#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kUIColorFromRGB1(r,g,b) [UIColor \
colorWithRed:(float)r/255.0 \
green:(float)g/255.0 \
blue:(float)b/255.0 \
alpha:1.0]


#define HT_Main_Color               kUIColorFromRGB(0xFE5013)
#define HT_Main_Back_Color          kUIColorFromRGB(0xFAFAFA)
#define HT_Title_Color              kUIColorFromRGB(0x333333)
#define HT_Name_Color               kUIColorFromRGB(0x666666)
#define HT_Name_low_Color           kUIColorFromRGB(0x999999)
#define HT_PlaceHolder_Color        kUIColorFromRGB(0x999999)
#define HT_Back_Color               kUIColorFromRGB(0xEBEBEB)
#define HT_BodarLine_Color          kUIColorFromRGB(0xCCCCCC)
#define HT_Price_Color              kUIColorFromRGB(0xFF0000)


#define JH_Font(font)               [UIFont systemFontOfSize:(float)font]
#define JH_Bold_Font(font)          [UIFont fontWithName:@"Helvetica-Bold" size:(float)font]


#endif /* ColorDefine_h */
