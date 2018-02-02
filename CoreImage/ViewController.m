//
//  ViewController.m
//  CoreImage
//
//  Created by lina on 2018/1/25.
//  Copyright © 2018年 lisa. All rights reserved.
//

#import "ViewController.h"

//滤镜类型
typedef NS_ENUM(int,Stype) {
    Type_CISepiaTone = 0,
    Type_CIGaussianBlur,
    Type_CIColorPosterize,
    Type_CIMinimumComponent,
    Type_CIPhotoEffectChrome,
    Type_CIPhotoEffectFade,
    Type_CICrystallize,
    Type_CIComicEffect,
    Type_CISpotLight,
};

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain)UISlider *slider;
@property(nonatomic,retain)UISegmentedControl *segmentControl;
@property(nonatomic,assign)Stype type;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,copy) NSString *filterName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
  
    UIImage *image = [UIImage imageNamed:@"wife.JPG"];
    _image = image;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,100, self.view.frame.size.width - 40, (image.size.height / image.size.width) * (self.view.frame.size.width - 40))];
    _imageView.userInteractionEnabled = YES;
    [_imageView setImage:_image];
    [self.view addSubview:_imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_imageView.frame) + 30, _imageView.frame.size.width, 90)];
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0f;
    [self.view addSubview:view];
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(50,8,200,20)];
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0;
    _slider.continuous = YES;
    [_slider addTarget:self action:@selector(valueChange)forControlEvents:UIControlEventValueChanged];
    [view addSubview:_slider];

    UISegmentedControl *seg1 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_slider.frame) + 10,view.frame.size.width - 20,40)];
    [seg1 insertSegmentWithTitle:@"色调设置"atIndex:0 animated:YES];
    [seg1 insertSegmentWithTitle:@"模糊设置"atIndex:1 animated:YES];
    [seg1 addTarget:self action:@selector(selectAction:)forControlEvents:UIControlEventValueChanged];
    [view addSubview:seg1];
    
    _segmentControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(view.frame) + 30,self.view.frame.size.width - 20,40)];
    [_segmentControl insertSegmentWithTitle:@"0"atIndex:0 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"1"atIndex:1 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"2"atIndex:2 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"3"atIndex:3 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"4"atIndex:4 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"5"atIndex:5 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"6"atIndex:6 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"7"atIndex:7 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"8"atIndex:8 animated:YES];
    [_segmentControl addTarget:self action:@selector(ButtonAction)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentControl];
    
    CGFloat widthInteger = (self.view.frame.size.width - 200) / 3;
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(widthInteger, CGRectGetMaxY(_segmentControl.frame) + 20, 100, 20)];
    [photoButton setTitle:@"更换图片" forState:UIControlStateNormal];
    [photoButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoButton.frame) + widthInteger, CGRectGetMaxY(_segmentControl.frame) + 20, 100, 20)];
    [saveButton setTitle:@"保持图片" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    //获取滤镜名字
//    NSArray* filters =  [CIFilter filterNamesInCategory:kCICategoryBlur];
//    for (NSString* filterName in filters) {
//        NSLog(@"filter name:%@",filterName);
//        // 我们可以通过filterName创建对应的滤镜对象
//        CIFilter* filter = [CIFilter filterWithName:filterName];
//        NSDictionary* attributes = [filter attributes];
//        // 获取属性键/值对（在这个字典中我们可以看到滤镜的属性以及对应的key）
//        NSLog(@"filter attributes:%@",attributes);
//    }
}


-(void)selectAction:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            self.type = Type_CISepiaTone;
            [self filterSepiaTone];
        }
            break;
        default:
        {
            self.type = Type_CIGaussianBlur;
            [self filterGaussianBlur];
        }
        break;
    }
}

- (void)valueChange
{
    switch (self.type) {
        case Type_CISepiaTone:
        {
            [self filterSepiaTone];
        }
            break;
            
        default:
        {
            [self filterGaussianBlur];
        }
            break;
    }
}

-(void)ButtonAction
{
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
        {
            self.filterName = @"CISepiaTone";
            [self filter];
        }
            break;
            
        case 1:
        {
            self.filterName = @"CIGaussianBlur";
            [self filter];
        }
            break;
        case 2:
        {
            self.filterName = @"CIColorPosterize";
            [self filter];
        }
            break;
        case 3:
        {
            self.filterName = @"CIMinimumComponent";
            [self filter];
        }
            break;
        case 4:
        {
            self.filterName = @"CIPhotoEffectFade";
            [self filter];
        }
            break;
        case 5:
        {
            self.filterName = @"CICrystallize";
            [self filter];
        }
            break;
        case 6:
        {
            self.filterName = @"CIConvolution9Vertical";
            [self filter];
        }
            break;
        case 7:
        {
            self.filterName = @"CISpotLight";
            [self filter];
        }
            break;
        default:
        {
            //叠加模糊滤镜的效果
            self.filterName = @"CIBoxBlur";
            [self addFilter];
        }
            break;
    }
}

//旧色调处理
-(void)filterSepiaTone
{
    //获取图片
    CIImage *cimage = [CIImage imageWithCGImage:[_image CGImage]];
    //创建CIFilter
    CIFilter *sepiaTone = [CIFilter filterWithName:@"CISepiaTone"];
    //设置滤镜输入参数
    [sepiaTone setValue:cimage forKey:@"inputImage"];
    //获取滑块的Value，设置色调强度
    [sepiaTone setValue:[NSNumber numberWithFloat:[_slider value]]forKey:@"inputIntensity"];
    //创建处理后的图片
    CIImage *resultImage = [sepiaTone valueForKey:@"outputImage"];
    //创建CIContext对象(默认值，传入nil)
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:resultImage fromRect:CGRectMake(0,0,self.image.size.width,self.image.size.height)];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    [_imageView setImage:image];
    CFRelease(imageRef);
}
//模糊设置处理
-(void)filterGaussianBlur
{
    CIImage *image = [CIImage imageWithCGImage:[_image CGImage]];
    CIFilter *gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlur setValue:image forKey:@"inputImage"];
    [gaussianBlur setValue:[NSNumber numberWithFloat:_slider.value*10] forKey:@"inputRadius"];
    CIImage *resultImage = [gaussianBlur valueForKey:@"outputImage"];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:resultImage fromRect:CGRectMake(0,0,self.image.size.width,self.image.size.height)];
    UIImage *currImg = [UIImage imageWithCGImage:imageRef];
    [_imageView setImage:currImg];
    CFRelease(imageRef);
}

- (void)filter
{
    //防止线程阻塞，用GCD异步执行滤镜与渲染操作，在获取渲染后的照片以后，返回主线程进行界面的更新。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //获取图片
        CIImage *image = [CIImage imageWithCGImage:[_image CGImage]];
        //创建CIFilter
        CIFilter *filter = [CIFilter filterWithName:self.filterName];
        //设置滤镜输入参数
        [filter setValue:image forKey:kCIInputImageKey];
        //进行默认设置
        [filter setDefaults];
        //创建CIContext对象
        CIContext *context = [CIContext contextWithOptions:nil];
        //创建处理后的图片
        CIImage *resultImage = filter.outputImage;
        CGImageRef imageRef = [context createCGImage:resultImage fromRect:CGRectMake(0,0,self.image.size.width,self.image.size.height)];
        UIImage *resultImg = [UIImage imageWithCGImage:imageRef];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [_imageView setImage:resultImg];
            CFRelease(imageRef);
        });
    });
}

//再次添加滤镜  形成滤镜链 不能再CIImage中重复添加
- (void)addFilter{
    CIImage *image = [CIImage imageWithCGImage:[_imageView.image CGImage]];
    CIFilter *filter = [CIFilter filterWithName:self.filterName];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setDefaults];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultImage = [context createCGImage:filter.outputImage fromRect:CGRectMake(0,0,self.image.size.width,self.image.size.height)];
    [_imageView setImage:[UIImage imageWithCGImage:resultImage]];
}

#pragma mark - 二维码和条形码
+ (UIImage *)barCodeImageWithUrl:(NSString *)url
{
    // 1.将字符串转换成NSData
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 2.创建条形码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 3.恢复滤镜的默认属性
    [filter setDefaults];
    // 4.设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5.获得滤镜输出的图像
    CIImage *urlImage = [filter outputImage];
    // 6.将CIImage 转换为UIImage
    UIImage *image = [UIImage imageWithCIImage:urlImage];
    return image;
}

+ (UIImage *)twoDimensionCodeWithUrl:(NSString *)url size:(CGFloat)size
{
    // 1.将字符串转换成NSData
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 2.创建二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 3.恢复默认
    [filter setDefaults];
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 5.获取滤镜输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 6.此时生成的还是CIImage，可以通过下面方式生成一个固定大小的UIImage
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 7.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 8.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 图片保存
- (void)photoAction:(UIButton *)sender{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

//把图片放在图片视图上
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _imageView.image = image;
    _image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//图片保存
- (void)saveAction:(UIButton *)sender{
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [al addAction:action];
    [self presentViewController:al animated:YES completion:nil];
}


@end
