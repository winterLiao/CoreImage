//
//  DetectorViewController.m
//  CoreImage
//
//  Created by 廖文韬 on 2018/1/31.
//  Copyright © 2018年 lisa. All rights reserved.
//

#import "DetectorViewController.h"

#define ConvertX (self.imageView.frame.size.width) / _image.size.width
#define ConvertY (self.imageView.frame.size.height) / _image.size.height

@interface DetectorViewController ()
@property(nonatomic, retain)UIImageView *imageView;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, retain)UIImageView *qrImageView;
@property(nonatomic, strong)UIImage *qrImage;
@end

@implementation DetectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *faceButton = [[UIButton alloc] initWithFrame:CGRectMake(20 , 60, 100, 20)];
    [faceButton setTitle:@"人脸识别" forState:UIControlStateNormal];
    [faceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(detectorWithFaceFeature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faceButton];

    UIImage *image = [UIImage imageNamed:@"ym.jpg"];
    _image = image;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,100, self.view.frame.size.width - 40, (image.size.height / image.size.width) * (self.view.frame.size.width - 40))];
//    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,100, image.size.width, image.size.height)];
    _imageView.userInteractionEnabled = YES;
    [_imageView setImage:image];
    [self.view addSubview:_imageView];
    
    
    UIButton *qrButton = [[UIButton alloc] initWithFrame:CGRectMake(20 , CGRectGetMaxY(_imageView.frame) + 20, 100, 20)];
    [qrButton setTitle:@"二维码扫描" forState:UIControlStateNormal];
    [qrButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [qrButton addTarget:self action:@selector(detectorWithQRCodeFeature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qrButton];
    
    _qrImage = [UIImage imageNamed:@"QRCode"];
    _qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(qrButton.frame) + 20,_qrImage.size.width, _qrImage.size.height)];
    _qrImageView.userInteractionEnabled = YES;
    [_qrImageView setImage:_qrImage];
    [self.view addSubview:_qrImageView];
}

/**
 人脸识别
 */
- (void)detectorWithFaceFeature
{
    CIImage *cImage = [CIImage imageWithCGImage:_image.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //设置高精度人脸识别器
    NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:param];

    //设置微笑和闭眼识别器
    NSDictionary *options = @{CIDetectorSmile: [NSNumber numberWithBool:true], CIDetectorEyeBlink:[NSNumber numberWithBool:true]};
    
    NSArray *detectResult = [faceDetector featuresInImage:cImage options:options];
    UIView * resultView = [[UIView alloc] initWithFrame:_imageView.frame];
    [self.view addSubview:resultView];
    
    
    for (CIFaceFeature * faceFeature in detectResult) {
        //获取脸部视图
        UIView *faceView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.bounds.origin.x * ConvertX, faceFeature.bounds.origin.y * ConvertY, faceFeature.bounds.size.width * ConvertX, faceFeature.bounds.size.height * ConvertY)];
        faceView.layer.borderColor = [UIColor greenColor].CGColor;
        faceView.layer.borderWidth = 1;
        [resultView addSubview:faceView];
        
        //左眼位置
        if (faceFeature.hasLeftEyePosition) {
            UIView * leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            [leftEyeView setCenter:CGPointMake(faceFeature.leftEyePosition.x * ConvertX, faceFeature.leftEyePosition.y * ConvertY)];
            leftEyeView.layer.borderWidth = 1;
            leftEyeView.layer.borderColor = [UIColor greenColor].CGColor;
            [resultView addSubview:leftEyeView];
        }
        
        //右眼位置
        if (faceFeature.hasRightEyePosition) {
            UIView *rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            [rightEyeView setCenter:CGPointMake(faceFeature.rightEyePosition.x * ConvertX, faceFeature.rightEyePosition.y * ConvertY)];
            rightEyeView.layer.borderWidth = 1;
            rightEyeView.layer.borderColor = [UIColor greenColor].CGColor;
            [resultView addSubview:rightEyeView];
        }
        
        //嘴巴位置
        if (faceFeature.hasMouthPosition) {
            UIView *mouthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
            [mouthView setCenter:CGPointMake(faceFeature.mouthPosition.x * ConvertX, faceFeature.mouthPosition.y * ConvertY)];
            mouthView.layer.borderWidth = 1;
            mouthView.layer.borderColor = [UIColor greenColor].CGColor;
            [resultView addSubview:mouthView];
        }
        
        //具体特征识别
        if (faceFeature.hasSmile) {
            NSLog(@"再笑");
        }
        if (faceFeature.leftEyeClosed) {
            NSLog(@"左眼闭了");
        }
        if (faceFeature.rightEyeClosed) {
            NSLog(@"右眼闭了");
        }
    }
    
    [resultView setTransform:CGAffineTransformMakeScale(1, -1)];
}

/**
 二维码扫描
 */
- (void)detectorWithQRCodeFeature
{
    CIDetector *qrCodeDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSData *imageData = UIImagePNGRepresentation(_qrImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    NSArray *features = [qrCodeDetector featuresInImage:ciImage];
    CIQRCodeFeature *feature = [features objectAtIndex:0];
    NSString *scannedResult = feature.messageString;
    NSLog(@"%@",scannedResult);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
