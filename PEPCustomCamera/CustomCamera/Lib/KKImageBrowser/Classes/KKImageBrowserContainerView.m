//
//  KKImageBrowserContainerView.m
//  KKImageBrowser_Example
//
//  Created by Hansen on 11/17/21.
//  Copyright © 2021 chenghengsheng. All rights reserved.
//

#import "KKImageBrowserContainerView.h"
#import "KKImageBrowserContainerCell.h"
#import "UIImageView+WebCache.h"

@interface KKImageBrowserContainerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *placeholderView;

@property (nonatomic, assign) UIView *weakView;
@property (nonatomic, assign) BOOL cacheStatusBarHidden;

@end

@implementation KKImageBrowserContainerView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundView];
    //
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerClass:[KKImageBrowserContainerCell class] forCellWithReuseIdentifier:@"KKImageBrowserContainerCell"];
    //增加占位图
    self.placeholderView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.placeholderView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.placeholderView];
}

- (void)removeShow{
    //复原状态栏
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //隐藏状态栏
    //状态栏优先UIApplication控制 UIViewControllerBasedStatusBarAppearance -> NO
    //状态栏优先UIViewController控制 UIViewControllerBasedStatusBarAppearance -> YES
    [[UIApplication sharedApplication] setStatusBarHidden:self.cacheStatusBarHidden];
    #pragma clang diagnostic pop
    self.placeholderView.hidden = NO;
    //qq
    UIView *view = self.weakView;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect f1 = window.bounds;
    CGRect f2 = [view convertRect:view.bounds toView:window];
    if (view == nil) {
        CGPoint point = window.center;
        f2 = CGRectMake(point.x, point.y, 0, 0);
    }
    self.collectionView.alpha = 0;
    self.frame = f1;
    self.backgroundView.frame = f1;
    //执行动画
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0;
        self.placeholderView.frame = f2;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.whenDidHideImageBrowser) {
            self.whenDidHideImageBrowser();
        }
    }];
}

//展示
- (void)showToView:(UIView *) toView {
    if (self.images.count == 0) {
        NSAssert(NO, @"图片内容不能为空");
        return;
    }
    //记录状态栏
    self.cacheStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    //隐藏状态栏
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    #pragma clang diagnostic pop
    //
    NSInteger index = self.index;
    UIView *view = nil;
    self.weakView = view;
    [self.placeholderView sd_setImageWithURL:nil];
    //
    UIView *window = toView;
    CGRect f1 = [view convertRect:view.bounds toView:window];
    if (view == nil) {
        CGPoint point = window.center;
        f1 = CGRectMake(point.x, point.y, 0, 0);
    }
    CGRect f2 = window.bounds;
    self.frame = f2;
    self.backgroundView.frame = f2;
    self.backgroundView.alpha = 0;
    self.placeholderView.frame = f1;
    //集合试图
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
    self.collectionView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
        self.placeholderView.frame = self.bounds;
    } completion:^(BOOL finished) {
        self.collectionView.contentOffset = CGPointMake(index * f2.size.width, 0);
        self.placeholderView.hidden = YES;
        self.collectionView.alpha = 1;
    }];
    [window addSubview:self];
    if (self.whenDidShowImageBrowser) {
        self.whenDidShowImageBrowser();
    }
}

- (void)layoutSubviews {
    if (!CGRectEqualToRect(self.collectionView.frame, self.bounds)) {
        self.backgroundView.frame = self.bounds;
        self.collectionView.frame = self.bounds;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}


- (void)setImages:(NSArray<UIImage *> *)images{
    _images = images;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *imageStr = self.images[indexPath.row];
    KKImageBrowserContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KKImageBrowserContainerCell" forIndexPath:indexPath];
    cell.imageStr = imageStr;
    cell.weakBackgroundView = self.backgroundView;
    __weak typeof (self) weakSelf = self;
    cell.whenChangeBackgroundAlpha = ^(CGFloat alpha) {
        if (weakSelf.whenChangeBackgroundAlpha) {
            weakSelf.whenChangeBackgroundAlpha(alpha);
        }
    };
    cell.whenTapOneActionClick = ^(KKImageBrowserContainerCell * _Nonnull cell) {
        [weakSelf removeShow];
    };
    cell.whenTapTwoActionClick = ^(KKImageBrowserContainerCell * _Nonnull cell) {
        
    };
    cell.whenNeedHideAction = ^(KKImageBrowserContainerCell * _Nonnull cell) {
        weakSelf.placeholderView.frame = cell.scrollView.frame;
        [weakSelf removeShow];
    };
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self whenNeedChangeWeakView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        //进入，不操作
    }else{
        //不进入，自动播放判断
        [self whenNeedChangeWeakView];
    }
}

//需要修改weakview
- (void)whenNeedChangeWeakView{
    CGPoint point = self.collectionView.contentOffset;
    point.x += self.center.x;
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    self.weakView = nil;
    if (self.whenNeedUpdateIndex) {
        self.whenNeedUpdateIndex(indexPath.row);
    }
}

@end
