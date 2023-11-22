//
//  PEPCustomCameraBottomView.h
//  PEPCustomCamera
//
//  Created by ErMeng Zhang on 2023/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PEPCustomCameraBottomView;

@protocol PEPCoverCellDelegate <NSObject>

- (void)deleteItemWithIndex:(NSInteger)index;

@end

@interface PEPCoverCell : UICollectionViewCell

@property (nonatomic, weak) id<PEPCoverCellDelegate>delegate;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end


@protocol PEPCustomCameraBottomViewDelegate <NSObject>

- (void)bottomView:(PEPCustomCameraBottomView *)bottomView didSelectItemIndex:(NSInteger)index;

@end

@interface PEPCustomCameraBottomView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,PEPCoverCellDelegate>

/**
 图片列表
 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/**
 拍照
 */
@property (nonatomic, strong) UIButton *takeBtn;
/**
 相册
 */
@property (nonatomic, strong) UIButton *albumBtn;
/**
 上传
 */
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<PEPCustomCameraBottomViewDelegate>delegate;

- (void)takePhotoDataImage:(NSMutableArray *)imageArray;

@end

NS_ASSUME_NONNULL_END
