//
//  WY_PhotoTableViewCell.m
//  MigratoryBirds
//
//  Created by wangyang on 2018/6/30.
//  Copyright © 2018年 wangyang. All rights reserved.
//

#import "WY_PhotoTableViewCell.h"
#import "MS_PhotoCarCollectionViewCell.h"


@interface WY_PhotoTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;



@property (nonatomic , strong) NSMutableArray *imgaeArr;/* <#注释#> */

@property (nonatomic) int maxCount;

@end


@implementation WY_PhotoTableViewCell



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self collView];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect )frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self collView];
    }
    
    return self;
}


//初始化cillectionview
- (void)collView{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, MSScreenW, kHeight((81*3 + 6*4)*2)) collectionViewLayout:flowLayout];
    
    
    [self.collectionView registerClass:[MS_PhotoCarCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCarsCell"];
    
    //    [self.collectionView registerClass:[MS_FunctionCollectionViewCell class] forCellWithReuseIdentifier:@"functionCell"];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    
    
}

#pragma mark - UICollectionViewDelegate (CollectionView)


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return (self.imgaeArr.count +1) >=self.maxCount ? self.maxCount : self.imgaeArr.count +1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *contentCell = nil;
    if (self.imgaeArr.count == 0) {
        if (indexPath.row == 0) {
            MS_PhotoCarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCarsCell" forIndexPath:indexPath];
            cell.addPhoto .image = [UIImage imageNamed:@"service_btn_addphoto"];
            cell.deletePhoto.hidden = YES;
            contentCell = cell;
            
        }
    }else{
        if (indexPath.row == self.imgaeArr.count) {
            MS_PhotoCarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCarsCell" forIndexPath:indexPath];
            cell.addPhoto .image = [UIImage imageNamed:@"service_btn_addphoto"];
            cell.deletePhoto.hidden = YES;
            contentCell = cell;
        }else{
            MS_PhotoCarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCarsCell" forIndexPath:indexPath];
//            [cell.addPhoto sd_setImageWithURL:[NSURL URLWithString:self.imgaeArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"" ]];
            
            [cell.addPhoto setImage:self.imgaeArr[indexPath.row][@"image"]];
            cell.deletePhoto.hidden = NO;
            [cell.deletePhoto addTarget:self action:@selector(deletePhotoClick:) forControlEvents:(UIControlEventTouchUpInside)];
            contentCell = cell;
        }
    }
    return contentCell;
    
    
}

/// 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate IndexPath:indexPath];
}

//删除图片
-(void)deletePhotoClick:(UIButton *)sender
{
    MS_PhotoCarCollectionViewCell *cell = (MS_PhotoCarCollectionViewCell *)[sender superview].superview.superview;
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    [self.imgaeArr removeObjectAtIndex:path.row];
    [self.collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(deleteIndex:)]) {
        [self.delegate deleteIndex:path.row];
    }
}

-(void)imgArr:(NSMutableArray *)imgArr maxCount:(int)mCount{
    self.imgaeArr = imgArr;
    self.maxCount = mCount;
    [self.collectionView reloadData];
}



#pragma mark - UICollectionViewDelegateFlowLayout
// 设置cell的宽度和高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(kWidth(81*2),kWidth(81*2));
    
}

// 设置cell间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return kWidth(12*2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return kWidth(0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    return UIEdgeInsetsMake(0,kWidth(12*2),0,kWidth(12*2));
    
}



@end
