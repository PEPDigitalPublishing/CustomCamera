//
//  ZEMCustomCameraViewController.m
//  MyPrivateProduct
//
//  Created by pep on 2022/9/1.
//

#import "PEPCustomCameraViewController.h"
#import "PEPCameraManager.h"
#import <Photos/Photos.h>
#import "PEPCustomCameraCoverView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/UIView+TZLayout.h>
#import "PEPCustomCameraHeader.h"
#import "KKImageBrowser.h"

@interface PEPCustomCameraViewController ()<ZEMCustomCameraCoverViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) PEPCameraManager *cameraManager;
@property (nonatomic, strong) UIButton *takeBtn;
@property (nonatomic, strong) PEPCustomCameraCoverView *coverView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation PEPCustomCameraViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [self.cameraManager stopRunning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [self.cameraManager startRunning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.coverView.frame = self.view.bounds;
    CGFloat width = (kMinScreenWidth - 70)/6;
    CGFloat height = width + 120 + JH_TabbarSafeBottomMargin;
    self.containerView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - height);
    [self.cameraManager resetPreviewRect:CGRectMake(0, 0, KScreenWidth, KScreenHeight + 60 - height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = (kMinScreenWidth - 70)/6;
    CGFloat height = width + 120 + JH_TabbarSafeBottomMargin;
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - height)];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerView];
    
    self.cameraManager = [[PEPCameraManager alloc] init];
    
    [self.cameraManager configureWithtargetViewLayer:self.containerView previewRect:CGRectMake(0, 0, KScreenWidth, KScreenHeight - height)];
    
    [self.view addSubview:self.coverView];
    
    self.imageArray = [[NSMutableArray alloc] init];
    
    [self.cameraManager startRunning];
}

#pragma mark -- coverViewDelegate

- (void)dismiss {
    [self.cameraManager stopRunning];
    [self.cameraManager removeAllObserver];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePhoto {
    [self takeBtnClick];
}

#pragma mark -- 拍照

- (void)takeBtnClick {
    if (self.imageArray.count >= 4) {
        
        [MBProgressHUD showNormalText:@"最多上传4张图片" toview:self.view];
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    __weak typeof(self) weakSelf = self;
    [self.cameraManager takePicture:^(UIImage * _Nonnull stillImage) {
        [weakSelf.imageArray addObject:stillImage];
        [weakSelf.coverView takePhotoDataImage:weakSelf.imageArray];
    }];
}

#pragma mark -- 打开相册
- (void)openAlbum {
    if (self.imageArray.count >= 4) {
        [MBProgressHUD showNormalText:@"最多可选择4张图片" toview:self.view];
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 - self.imageArray.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.selectedAssets = [NSMutableArray new]; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    if ([TZCommonTools tz_isLandscape]) {
        top = 30;
        widthHeight = self.view.tz_height - 2 * left;
        left = (self.view.tz_width - widthHeight) / 2;
    }
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
   
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf.imageArray addObjectsFromArray:photos];
        [weakSelf.coverView takePhotoDataImage:weakSelf.imageArray];
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 上传
- (void)uploadPhotos {
    if (self.imageArray.count == 0) {
        [MBProgressHUD showNormalText:@"请选择图片" toview:self.view];
        return;
    }
    if (self.uploadPhotoBlock) {
        self.uploadPhotoBlock(self.imageArray);
    }
    
    [self.cameraManager stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 点击图片

- (void)coverView:(PEPCustomCameraCoverView *)coverView didSelectIndex:(NSInteger)index {
    KKImageBrowser *vc = [[KKImageBrowser alloc] init];
    vc.images = self.imageArray;
    vc.index = index;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - lazy

- (PEPCustomCameraCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[PEPCustomCameraCoverView alloc] initWithFrame:self.view.bounds];
        _coverView.delegate = self;
    }
    return _coverView;
}

#pragma mark -- UIInterfaceOrientation

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

- (BOOL)shouldAutorotate {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
