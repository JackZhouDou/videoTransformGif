//
//  VideoCollectionViewCell.m
//  VideoToGif
//
//  Created by du zhou on 2017/11/30.
//  Copyright © 2017年 du zhou. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoModel.h"
@interface VideoCollectionViewCell ()
@property (nonatomic, strong) PHAsset *tempAsset;

@end

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    self.videoView.contentMode =  UIViewContentModeScaleAspectFill;
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setVideoViewModel:(id)videoModel withOptions:(id)optionsVideo indexpatchNumber:(NSInteger)rowNumber {
    
    PHAsset *phasset = (PHAsset *)videoModel;
    

    self.playerView.image = [UIImage imageNamed:@"player"];
    if (phasset != self.tempAsset) {
        VideoModel *model = self.arrayImage[rowNumber];
        if (model.dataOf) {
            self.videoView.image = [UIImage imageWithData:model.dataOf];
            self.timeLable.text = model.timeString;
        }else{
            __weak typeof(self) weakSelf = self;
            __block NSInteger number = rowNumber;
            [[PHImageManager defaultManager]requestAVAssetForVideo:(PHAsset *)videoModel options:(PHVideoRequestOptions *)optionsVideo resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                [weakSelf displayerVideoTransfromImage:asset number:number];
            }];
            self.tempAsset = phasset;
        }
        
    }
  
    
}

- (void)displayerVideoTransfromImage:(AVAsset *)asset number:(NSInteger)number {
    

// 转换成图片集合
     AVAssetImageGenerator *imagegenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    NSError *error = nil;
    //截取第一秒的第一帧
    CMTime time = CMTimeMake(1, 1);
    CMTime actualTime;
   CGImageRef cgImage =  [imagegenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    CMTimeShow(asset.duration);
//    CMTimeShow(actualTime);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
     dispatch_async(dispatch_get_main_queue(), ^{
         NSInteger total = [[NSString stringWithFormat:@"%0.0f", CMTimeGetSeconds(asset.duration)] integerValue];
         NSInteger hour = total / 3600;
         NSInteger minute = (total - hour * 3600) / 60;
         NSInteger second = total % 60;
         NSString *timeOf = @"";
         if (hour > 0) {
             timeOf = [NSString stringWithFormat:@"%ld:", hour];
         }
         //视频时长
         timeOf = [NSString stringWithFormat:@"%@%ld:%ld", timeOf, minute, second];
         
        self.videoView.image = image;
         self.timeLable.text = timeOf;
         VideoModel *model = [self.arrayImage objectAtIndex:number];
         model.dataOf = UIImageJPEGRepresentation(image, 1);
         model.timeString = timeOf;
     });
    CGImageRelease(cgImage);
    
}
@end
