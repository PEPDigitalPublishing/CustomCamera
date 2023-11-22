//
//  KKImageBrowser.h
//  KKImageBrowser_Example
//
//  Created by Hansen on 11/18/21.
//  Copyright © 2021 chenghengsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKImageBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ScrollDidEndBlock)(NSInteger index);

@interface KKImageBrowser : UIViewController

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSArray <UIImage *> *images;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) ScrollDidEndBlock scrollDidEndBlock;

@end

NS_ASSUME_NONNULL_END
