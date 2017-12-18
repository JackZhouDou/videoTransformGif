//
//  VideoSeleceViewController.h
//  VideoToGif
//
//  Created by du zhou on 2017/11/29.
//  Copyright © 2017年 du zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^videoModelBlock)(id video);
@class VideoSelectedManger;
@interface VideoSeleceViewController : UIViewController
- (void)PhotosGetVideoDatavideoSelectedManger:(VideoSelectedManger *)videoManger;
@end
