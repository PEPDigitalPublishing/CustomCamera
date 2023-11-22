//
//  ZEMCustomCameraCoverView.m
//  MyPrivateProduct
//
//  Created by pep on 2022/9/5.
//

#import "PEPCustomCameraCoverView.h"
#import "PEPCustomCameraHeader.h"
#import "PEPCustomCameraBottomView.h"

@interface PEPCustomCameraCoverView ()<PEPCustomCameraBottomViewDelegate>

//返回
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) PEPCustomCameraBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation PEPCustomCameraCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self loadSubViews];
    }
    return self;
}


- (void)loadSubViews {
    [self addSubview:self.backBtn];
    [self addSubview:self.bottomView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.mas_top).offset(JH_StatusBarHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    CGFloat width = (kMinScreenWidth - 70)/6;
    CGFloat height = width + ([[UIDevice currentDevice].model containsString:@"iPad"]?60:90) + JH_TabbarSafeBottomMargin;
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(height);
    }];
}

- (void)takePhotoDataImage:(NSMutableArray *)imageArray {
    self.imageArray = imageArray;
    [self.bottomView takePhotoDataImage:self.imageArray];
}

#pragma mark - PEPCustomCameraBottomViewDelegate

- (void)bottomView:(PEPCustomCameraBottomView *)bottomView didSelectItemIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(coverView:didSelectIndex:)]) {
        [self.delegate coverView:self didSelectIndex:index];
    }
}

#pragma mark -- action

- (void)backBtnClick {
    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

//拍照
- (void)takeBtnClick {
    if ([self.delegate respondsToSelector:@selector(takePhoto)]) {
        [self.delegate takePhoto];
    }
}
//相册
- (void)albumBtnClick {
    if ([self.delegate respondsToSelector:@selector(openAlbum)]) {
        [self.delegate openAlbum];
    }
}

//上传
- (void)uploadBtnClick {
    if ([self.delegate respondsToSelector:@selector(uploadPhotos)]) {
        [self.delegate uploadPhotos];
    }
}


#pragma mark -- lazy

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.backgroundColor = UIColor.whiteColor;
        _backBtn.layer.cornerRadius = 22;
        _backBtn.layer.masksToBounds = YES;
        [_backBtn setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (PEPCustomCameraBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PEPCustomCameraBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor blackColor];
        [_bottomView.takeBtn addTarget:self action:@selector(takeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.albumBtn addTarget:self action:@selector(albumBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.uploadBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
