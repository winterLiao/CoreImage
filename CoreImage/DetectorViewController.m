//
//  DetectorViewController.m
//  CoreImage
//
//  Created by 廖文韬 on 2018/1/31.
//  Copyright © 2018年 lisa. All rights reserved.
//

#import "DetectorViewController.h"

@interface DetectorViewController ()
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)UIImageView *imageView;
@end

@implementation DetectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"wife.JPG"];
    _image = image;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,100, self.view.frame.size.width - 40, (image.size.height / image.size.width) * (self.view.frame.size.width - 40))];
    _imageView.userInteractionEnabled = YES;
    [_imageView setImage:_image];
    [self.view addSubview:_imageView];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
