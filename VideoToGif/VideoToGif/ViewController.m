//
//  ViewController.m
//  VideoToGif
//
//  Created by du zhou on 2017/11/29.
//  Copyright © 2017年 du zhou. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import <CoreImage/CoreImage.h>
#import "VideoSelectedManger.h"
#import "VideoSeleceViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayerViewGif;
@property (weak, nonatomic) IBOutlet UIButton *addVideo;
@property (nonatomic, strong) VideoSelectedManger *videoManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addActionVideo:(id)sender {
    //从相册里面添加图片
    __weak typeof(self) weakSlef = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status == PHAuthorizationStatusDenied) {
            NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
            
        }else if (status == PHAuthorizationStatusRestricted){
            NSLog(@"家长控制,不允许访问");
            
        }else if (status == PHAuthorizationStatusNotDetermined){
            NSLog(@"用户还没有做出选择");
        dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSlef pushSelectedVideo];
            });
           
            
        }else if (status == PHAuthorizationStatusAuthorized){
            NSLog(@"用户允许当前应用访问相册");
        dispatch_async(dispatch_get_main_queue(), ^{
                [weakSlef pushSelectedVideo];
            });
        }
    }];

    
    
}
- (void)pushSelectedVideo{
    __weak typeof(self) weakSlef = self;
    if (!self.videoManager) {
        self.videoManager = [VideoSelectedManger new];
    
        [self.videoManager PhotosGetVideoData:^(id video) {
            [weakSlef imageAnimation];
            
        }];
    }
    VideoSeleceViewController *videoController = [[VideoSeleceViewController alloc]init];
    [videoController PhotosGetVideoDatavideoSelectedManger:self.videoManager];
    
    [self presentViewController:videoController animated:YES completion:^{
        
    }];
    
}
//展示gif动画
- (void)imageAnimation{
    
    
    if (self.videoManager.totalImageArray.count) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSData *data in self.videoManager.totalImageArray) {
            
            [array addObject:[UIImage imageWithData:data]];
        }
        self.videoPlayerViewGif.animationImages = array;
        self.videoPlayerViewGif.animationDuration = self.videoManager.animationTimer;
        self.videoPlayerViewGif.animationRepeatCount = 0;
        [self.videoPlayerViewGif startAnimating];
        
    }
    
    
}

- (IBAction)savePhotoAction:(id)sender {
    
    if (self.videoManager) {
        [self.videoManager saveGifToPhoto:@"gif"];
        
    }
}

@end
