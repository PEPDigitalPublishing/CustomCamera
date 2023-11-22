//
//  ZEMCustomCameraViewController.h
//  MyPrivateProduct
//
//  Created by pep on 2022/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UploadPhotoBlock)(NSArray <UIImage *>*imageArray);

@interface PEPCustomCameraViewController : UIViewController

@property (nonatomic, copy) UploadPhotoBlock uploadPhotoBlock;

@end

NS_ASSUME_NONNULL_END
