//
//  VideoCollectionViewCell.h
//  VideoToGif
//
//  Created by du zhou on 2017/11/30.
//  Copyright © 2017年 du zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *playerView;
@property (nonatomic, strong) NSMutableArray *arrayImage;
- (void)setVideoViewModel:(id)videoModel withOptions:(id)optionsVideo indexpatchNumber:(NSInteger)rowNumber;

@end
