//
//  ZEMCameraManager.h
//  MyPrivateProduct
//
//  Created by pep on 2022/8/31.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//拍照后的回调，传递拍摄的照片
typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);

@interface PEPCameraManager : NSObject

@property (nonatomic, strong) AVCaptureSession *session;//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;//预览图层，来显示照相机拍摄到的画面
 
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;//AVCaptureDeviceInput对象是输入流
 
@property (nonatomic, strong) AVCapturePhotoOutput *stillImageOutput;//照片输出流对象
 
@property (nonatomic, assign) CGRect previewLayerFrame;//拍照区域

@property (nonatomic, strong) AVCaptureDevice *device;
 
/* 为其他类提供的自定义接口 */
 
//设置拍照区域 (其中targetView为要展示拍照界面的view)
- (void)configureWithtargetViewLayer:(UIView *)targetView previewRect:(CGRect)preivewRect;

//横竖屏刷新frame

- (void)resetPreviewRect:(CGRect)previewRect;
 
//拍照成功回调
- (void)takePicture:(DidCapturePhotoBlock)block;
 
//添加/移除相机浮层（如果有需求要在相机拍照区域添加浮层的时候使用）
- (void)addCoverImageWithImage:(UIImage *)image;
- (void)removeCoverImageWithImage:(UIImage *)image;
 
- (void)startRunning;
- (void)stopRunning;

//判断后置摄像头是否可用
- (BOOL)isRearCameraAvailable;

//判断是否拥有使用相机权限
- (BOOL)isAuthorizationCamera;

//删除通知

- (void)removeAllObserver;

@end

NS_ASSUME_NONNULL_END
