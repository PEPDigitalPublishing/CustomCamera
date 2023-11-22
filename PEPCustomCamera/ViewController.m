//
//  ViewController.m
//  PEPCustomCamera
//
//  Created by ErMeng Zhang on 2023/5/19.
//

#import "ViewController.h"
#import "PEPCustomCameraHeader.h"
#import "PEPCustomCameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn  setTitle:@"自定义相机" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:25];
    btn.layer.cornerRadius = 25;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(gotoCameraClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(50);
    }];
}

- (void)gotoCameraClick {
    PEPCustomCameraViewController *controller = [[PEPCustomCameraViewController alloc] init];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [controller setUploadPhotoBlock:^(NSArray<UIImage *> * _Nonnull imageArray) {
        //上传图片
        NSLog(@"上传图片 %@",imageArray);
    }];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
