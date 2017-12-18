//
//  VideoSeleceViewController.m
//  VideoToGif
//
//  Created by du zhou on 2017/11/29.
//  Copyright © 2017年 du zhou. All rights reserved.
//

#import "VideoSeleceViewController.h"
#import <Photos/Photos.h>
#import "VideoSelectedManger.h"
#import "VideoCollectionViewCell.h"
#import "VideoModel.h"
#define  KMainScreenRect [[UIScreen mainScreen] bounds]
#define KMainScreenStatusBarFrameRect [[UIApplication sharedApplication]statusBarFrame]
@interface VideoSeleceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) VideoSelectedManger *videoManager;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageDateArray;


//@property (nonatomic, strong) UIView * haerdView;

@end



@implementation VideoSeleceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSInteger numberOf = self.videoManager.assets.count;
    self.imageDateArray = [NSMutableArray array];
    for (NSInteger i = 0; i < numberOf; i++) {
        VideoModel *model = [VideoModel new];
        [self.imageDateArray addObject:model];
    }
    
    [self haerdViewInit];
  
    [self.collectionView reloadData];
    
}


- (void)haerdViewInit{

       UIView  *haerdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenRect.size.width, KMainScreenStatusBarFrameRect.size.height + 40.0)];
        haerdView.backgroundColor = [UIColor colorWithRed:250.0 / 255 green:250.0 / 255 blue:250.0 /255 alpha:1];
        [self.view addSubview:haerdView];
    
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setTitleColor:[UIColor redColor] forState:0];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        backButton.frame = CGRectMake(15.0, KMainScreenStatusBarFrameRect.size.height + 10.0, 50, 20);

        [backButton addTarget:self action:@selector(comBackController) forControlEvents:UIControlEventTouchUpInside];
        [haerdView addSubview:backButton];
   
}

/**
 返回
 */
- (void)comBackController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}

- (void)PhotosGetVideoDatavideoSelectedManger:(VideoSelectedManger *)videoManger{
    self.videoManager = videoManger;
   
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat space = 15.0f;
        CGFloat width = (KMainScreenRect.size.width - space * 4) / 3.0;
        CGFloat navHeight = KMainScreenStatusBarFrameRect.size.height + 40.0;
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15.0, 15, 15);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, navHeight, KMainScreenRect.size.width, KMainScreenRect.size.height -navHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"video"];
       
        
    }
    return _collectionView;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.videoManager.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
    cell.arrayImage = self.imageDateArray;
    [cell setVideoViewModel:self.videoManager.assets[indexPath.row] withOptions:self.videoManager.imageOptions indexpatchNumber:indexPath.row];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //处理开始
    [self.videoManager creatVideoComeToGifCurrentNumber:indexPath.row];
    [self comBackController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
