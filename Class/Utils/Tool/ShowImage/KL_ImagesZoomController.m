//
//  KL_ImagesZoomController.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//


#import "KL_ImagesZoomController.h"
#import "ZoomImgItem.h"
@interface KL_ImagesZoomController ()
{
    CGSize v_size;
    UITableView *m_TableView;
    UILabel *progressLabel;
}
@end

@implementation KL_ImagesZoomController

- (id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        v_size = size;
        [self _initView];
    }
    return self;
}

- (void)updateImageDate:(NSMutableArray *)objArr selectIndex:(NSInteger)index
{
    self.objs = objArr;
    [m_TableView reloadData];
    if (index >= 0 && index < self.objs.count) {
        NSInteger row = MAX(index, 0);
        [m_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        NSObject *objModel = [self.objs objectAtIndex:index];
        if ([objModel isKindOfClass:[IWPictureModel class]]) {
//            progressLabel.text = ((IWPictureModel*)objModel).msummary;
        }
    }
    
}

- (void)_initView
{
    m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)
                                               style:UITableViewStylePlain];
    m_TableView.delegate = self;
    m_TableView.dataSource = self;
    m_TableView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    m_TableView.showsVerticalScrollIndicator = NO;
    m_TableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    m_TableView.pagingEnabled = YES;
    m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_TableView.backgroundView = nil;
    m_TableView.backgroundColor = [UIColor blackColor];
    [self addSubview:m_TableView];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 45)];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.font = [UIFont systemFontOfSize:15];
    progressLabel.textAlignment = NSTextAlignmentLeft;
    progressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    progressLabel.numberOfLines = 2;
    [self addSubview:progressLabel];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objs.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idty = @"imgshowCell";
    ZoomImgItem *cell = [tableView dequeueReusableCellWithIdentifier:idty];
    if (nil == cell) {
        cell = [[ZoomImgItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idty];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    cell.size = self.bounds.size;
    NSObject *objModel = [self.objs objectAtIndex:indexPath.row];
    if ([objModel isKindOfClass:[IWPictureModel class]]) {
        cell.imgSize = ((IWPictureModel*)objModel).nssize_preview;
        cell.imgPictures = [NSString stringWithFormat:@"%@",((IWPictureModel*)objModel).nsthumbnail_pic];
        cell.imgName = [NSString stringWithFormat:@"%@",((IWPictureModel*)objModel).nsoriginal_pic];
    }
    
    _myCellIndex = indexPath.row;
    //调用代理
    if([_delegate respondsToSelector:@selector(KL_ImagesPageRun:)]) {
        [_delegate KL_ImagesPageRun:_myCellIndex];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.width;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
    NSObject *objModel = [self.objs objectAtIndex:index.row];
    if ([objModel isKindOfClass:[IWPictureModel class]]) {
//        progressLabel.text = ((IWPictureModel*)objModel).msummary;
    }
    
    _myCellIndex = index.row;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
    NSObject *objModel = [self.objs objectAtIndex:index.row];
    if ([objModel isKindOfClass:[IWPictureModel class]]) {
//        progressLabel.text = ((IWPictureModel*)objModel).msummary;
    }
    _myCellIndex = index.row;
    //调用代理
    if([_delegate respondsToSelector:@selector(KL_ImagesPageRun:)]) {
        [_delegate KL_ImagesPageRun:_myCellIndex];
    }
} 
@end
