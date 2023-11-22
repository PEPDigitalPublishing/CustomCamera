//
//  ZEMCameraManager.m
//  MyPrivateProduct
//
//  Created by pep on 2022/8/31.
//

#import "PEPCameraManager.h"
#import "PEPCustomCameraHeader.h"

@interface PEPCameraManager ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) UIView *preview;//展现拍照区域的view
@property (nonatomic, strong) UIImageView *coverImageView;//拍照区域浮层
 
@property (nonatomic, assign) BOOL isCaremaBack;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

@property (nonatomic, copy) DidCapturePhotoBlock photoBlock;
@property (nonatomic, assign) CGRect preivewRect;

@property (nonatomic, assign) UIInterfaceOrientation orientation;

@end

@implementation PEPCameraManager

//初始化的时候设置自己想要的默认属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isCaremaBack = YES;//默认后置摄像头
        self.flashMode = AVCaptureFlashModeOff;//默认闪光灯关闭
    }
    return  self;
}

- (void)dealloc {
    //销毁 设备旋转 通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification
                                                  object:nil];
}

//删除通知

- (void)removeAllObserver {
    //销毁 设备旋转 通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification
                                                  object:nil];
}

/**屏幕旋转的通知回调*/
- (void)orientChange:(NSNotification *)noti {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.orientation = orientation;
    self.previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeivceOrientation];
    switch (orientation) {
        case UIInterfaceOrientationUnknown:
            NSLog(@"未知");
            break;
        case UIInterfaceOrientationPortrait:
            NSLog(@"竖直");
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"屏幕倒立");
            break;
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"手机水平，home键在左边");
            break;
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"手机水平，home键在右边");
            break;
        default:
            break;
    }
}

- (AVCaptureVideoOrientation)videoOrientationFromCurrentDeivceOrientation {
    switch (self.orientation) {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
            break;
            
        case UIInterfaceOrientationUnknown:
            return AVCaptureVideoOrientationPortrait;
            break;
            
        default:
            break;
    }
}

#pragma mark -- 准备相关硬件
- (void)configureWithtargetViewLayer:(UIView *)targetView previewRect:(CGRect)preivewRect {
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    self.preivewRect = preivewRect;
    self.preview = targetView;
    //开始一些相机相关硬件配置
    [self addSession];//创建session 配置输入
    [self addStillImageOutput];//给session 配置输出
    [self addVideoPreviewLayerWithRect:preivewRect];//用session 创建 创建layer
    
}

- (void)startRunning {
    if (![self isRearCameraAvailable]) {
        [MBProgressHUD showNormalText:@"后置摄像头不可用" toview:kwindow];
        return;
    }
    
    if (![self isAuthorizationCamera]) {
        [MBProgressHUD showNormalText:@"应用相机权限受限，请在设置用启用" toview:kwindow];
        return;
    }
    
    [self addVideoPreviewLayerWithRect:self.preivewRect];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.session startRunning];
    });
}

- (void)stopRunning {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([self.session isRunning]) {
            [self.session stopRunning];
        }
        
        if (self->_previewLayer) {
            [self.previewLayer removeFromSuperlayer];
            self->_previewLayer = nil;
        }
    });
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    for ( AVCaptureDevice *device in discoverySession.devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}

#pragma mark - 拍照
- (void)takePicture:(DidCapturePhotoBlock)block {
    self.photoBlock = block;
    AVCapturePhotoSettings *set = [AVCapturePhotoSettings photoSettings];
    //关闭闪光灯
    if (self.device.hasFlash) {  // 判断设备是否有散光灯
        set.flashMode = AVCaptureFlashModeAuto;
    }
    [_stillImageOutput.connections.lastObject setVideoOrientation:[self videoOrientationFromCurrentDeivceOrientation]];
    [_stillImageOutput capturePhotoWithSettings:set delegate:self];
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error  API_AVAILABLE(ios(11.0)){
    if (!error) {
        // 使用该方式获取图片，可能图片会存在旋转问题，在使用的时候调整图片即可
        NSData *data = [photo fileDataRepresentation];
        UIImage *image = [UIImage imageWithData:data];
        if (self.photoBlock) {
            self.photoBlock(image);
        }
        // 对，就是上面的image
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark -- 添加移除浮层
- (void)addCoverImageWithImage:(UIImage *)image {
    _coverImageView.image = image;
}
- (void)removeCoverImageWithImage:(UIImage *)image{
    _coverImageView.image = nil;
 
}

- (void)addSession {
    if (!self.session) {
        AVCaptureSession *session = [[AVCaptureSession alloc]init];
        session.sessionPreset = AVCaptureSessionPresetPhoto;
        self.session = session;
        
        self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        if ([self.session canAddInput:self.deviceInput]) {
            [self.session addInput:self.deviceInput];
        }
    }
}

//判断后置摄像头是否可用
- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

//判断是否拥有使用相机权限
- (BOOL)isAuthorizationCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    }
    
    return YES;
}


- (void)addVideoPreviewLayerWithRect:(CGRect)previewRect {
    if (!self.previewLayer) {
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer = previewLayer;
        [self.preview.layer addSublayer:self.previewLayer];
    }
    self.previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeivceOrientation];
    self.previewLayer.frame = previewRect;
}

- (void)resetPreviewRect:(CGRect)previewRect {
    self.preivewRect = previewRect;
    self.previewLayer.frame = previewRect;
    
}

- (void)addStillImageOutput {
    if (!self.stillImageOutput) {
        self.stillImageOutput = [[AVCapturePhotoOutput alloc] init];
        if ([self.session canAddOutput:self.stillImageOutput]) {
            [self.session addOutput:self.stillImageOutput];
        }
    }
}


@end
