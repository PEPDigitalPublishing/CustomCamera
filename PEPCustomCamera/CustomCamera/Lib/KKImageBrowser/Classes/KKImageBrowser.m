//
//  KKImageBrowser.m
//  KKImageBrowser_Example
//
//  Created by Hansen on 11/18/21.
//  Copyright © 2021 chenghengsheng. All rights reserved.
//

#import "KKImageBrowser.h"
#import "KKImageBrowserContainerView.h"
#import "UIView+KKImageBrowser.h"
#import "PEPCustomCameraHeader.h"

@interface KKImageBrowser ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) KKImageBrowserContainerView *containerView;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation KKImageBrowser

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.bgImageView];
    UIImage *bgImage = [UIApplication sharedApplication].keyWindow.screenshotsImage;
    self.bgImageView.image = bgImage;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showImageBrowser];
    });
}

- (void)needUpdateIndex:(NSInteger )index{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld / %ld",index + 1,self.images.count];
    if (self.scrollDidEndBlock) {
        self.scrollDidEndBlock(index);
    }
}

- (void)showImageBrowser {
    KKImageBrowserContainerView *containerView = [[KKImageBrowserContainerView alloc] init];
    containerView.path = self.path;
    containerView.images = self.images;
    containerView.index = self.index;
    __weak typeof(self) weakSelf = self;
    containerView.whenDidHideImageBrowser = ^{
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    };
    containerView.whenChangeBackgroundAlpha = ^(CGFloat alpha) {
        //TODO
    };
    containerView.whenNeedUpdateIndex = ^(NSInteger index) {
        [weakSelf needUpdateIndex:index];
    };
    [containerView showToView:self.view];
    self.containerView = containerView;
    [containerView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top).offset(JH_NavigationBarHeight);
        make.right.equalTo(containerView.mas_right).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    [self needUpdateIndex:self.index];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.bgImageView.frame = bounds;
    self.containerView.frame = bounds;
}

- (void)toPopBack {
    [self.containerView removeShow];
}

#pragma mark - setters

- (void)setIndex:(NSInteger)index {
    _index = index;
    [self needUpdateIndex:index];
}

#pragma mark - getters

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = JH_Font(12);
        _numberLabel.backgroundColor = [kUIColorFromRGB(0x666666) colorWithAlphaComponent:0.5];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.layer.cornerRadius = 10;
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

@end
