//
//  ZEMCustomCameraCoverView.h
//  MyPrivateProduct
//
//  Created by pep on 2022/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PEPCustomCameraCoverView;
@protocol ZEMCustomCameraCoverViewDelegate <NSObject>

//返回
- (void)dismiss;
//拍照
- (void)takePhoto;
//打开相册
- (void)openAlbum;
//上传
- (void)uploadPhotos;

//点击图片放大
- (void)coverView:(PEPCustomCameraCoverView *)coverView didSelectIndex:(NSInteger)index;

@end

@interface PEPCustomCameraCoverView : UIView

@property (nonatomic, weak) id<ZEMCustomCameraCoverViewDelegate>delegate;

- (void)takePhotoDataImage:(NSMutableArray *)imageArray;

@end

NS_ASSUME_NONNULL_END
