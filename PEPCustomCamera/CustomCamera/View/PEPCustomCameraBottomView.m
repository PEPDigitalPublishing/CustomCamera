//
//  PEPCustomCameraBottomView.m
//  PEPCustomCamera
//
//  Created by ErMeng Zhang on 2023/5/22.
//

#import "PEPCustomCameraBottomView.h"
#import "PEPCustomCameraHeader.h"
#import "UIImageView+WebCache.h"
#import <Photos/Photos.h>

@implementation PEPCoverCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(-5);
            make.right.equalTo(self.contentView).offset(5);
            make.width.mas_equalTo(20.5);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(deleteItemWithIndex:)]) {
        [self.delegate deleteItemWithIndex:self.indexPath.row];
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_image"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end

@implementation PEPCustomCameraBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.takeBtn];
    [self addSubview:self.albumBtn];
    [self addSubview:self.uploadBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = (kMinScreenWidth - 70)/8 - 2;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(width+10);
    }];
    
    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.takeBtn);
        make.centerX.equalTo(self.takeBtn.mas_centerX).offset(-150);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.takeBtn);
        if (kIsiPhone){
            make.right.equalTo(@(-10));
        }else{
            make.centerX.equalTo(self.takeBtn.mas_centerX).offset(150);
        }
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
    [self getLastImage];
    
}

- (void)takePhotoDataImage:(NSMutableArray *)imageArray {
    self.imageArray = imageArray;
    [self.collectionView reloadData];
    NSString *title = [NSString stringWithFormat:@"上传(%d/4)",(int)imageArray.count];
    [self.uploadBtn setTitle:title forState:UIControlStateNormal];
}

- (void)getLastImage {
    __weak typeof(self) weakSelf = self;
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    PHAsset *asset = [assetsFetchResults firstObject];
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [weakSelf.albumBtn setBackgroundImage:result forState:UIControlStateNormal];
    }];
}

#pragma mark -- collctiondelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PEPCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PEPCoverCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.iconImageView.image = self.imageArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.backgroundColor = [self randomColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0.00000001f, 0.000001f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0.000001f, 0.000001f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kMinScreenWidth - 70)/8 - 2;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(bottomView:didSelectItemIndex:)]) {
        [self.delegate bottomView:self didSelectItemIndex:indexPath.row];
    }
}

- (void)deleteItemWithIndex:(NSInteger)index {
    [self.collectionView performBatchUpdates:^{
        [self.imageArray removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        NSString *title = [NSString stringWithFormat:@"上传(%d/4)",(int)self.imageArray.count];
        [self.uploadBtn setTitle:title forState:UIControlStateNormal];
    }completion:^(BOOL finished){
        [self.collectionView reloadData];
    }];
}

- (UIColor *)randomColor {
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}


- (UIButton *)takeBtn {
    if (!_takeBtn) {
        _takeBtn = [[UIButton alloc] init];
        _takeBtn.backgroundColor = [UIColor whiteColor];
        _takeBtn.layer.cornerRadius = 30;
        _takeBtn.layer.masksToBounds = YES;
        _takeBtn.layer.borderWidth = 3;
        _takeBtn.layer.borderColor = UIColor.lightGrayColor.CGColor;
    }
    return _takeBtn;
}

- (UIButton *)albumBtn {
    if (!_albumBtn) {
        _albumBtn = [[UIButton alloc] init];
        _albumBtn.backgroundColor = [UIColor blackColor];
        _albumBtn.layer.cornerRadius = 25;
        _albumBtn.layer.masksToBounds = YES;
        _albumBtn.layer.borderWidth = 2;
        _albumBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _albumBtn;
}

- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [[UIButton alloc] init];
        _uploadBtn.backgroundColor = HT_Main_Color;
        _uploadBtn.layer.cornerRadius = 5;
        _uploadBtn.layer.masksToBounds = YES;
        _uploadBtn.titleLabel.font = JH_Font(15);
        [_uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uploadBtn setTitle:@"上传(0/4)" forState:UIControlStateNormal];
        
    }
    return _uploadBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PEPCoverCell class] forCellWithReuseIdentifier:NSStringFromClass([PEPCoverCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
