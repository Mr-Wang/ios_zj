//
//  WY_InfomationModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_InfomationModel : MHObject

@property (nonatomic, readwrite, copy) NSString *id;
@property (nonatomic, readwrite, copy) NSString *keyword;
@property (nonatomic, readwrite, copy) NSString *infokey;
@property (nonatomic, readwrite, copy) NSString *infoid;
@property (nonatomic, readwrite, copy) NSString *infotype;
@property (nonatomic, readwrite, copy) NSString *infocontent;
@property (nonatomic, readwrite, copy) NSString *startdate;
@property (nonatomic, readwrite, copy) NSString *enddate;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *titletype;
@property (nonatomic, readwrite, copy) NSString *urlname;
@property (nonatomic, readwrite, copy) NSString *infodate;
@property (nonatomic, readwrite, copy) NSString *pubinwebdate;
@property (nonatomic, readwrite, copy) NSString *clicktimes;
@property (nonatomic, readwrite, copy) NSString *ordernum;
@property (nonatomic, readwrite, copy) NSString *zhuanzai;
@property (nonatomic, readwrite, copy) NSString *titlesize;
@property (nonatomic, readwrite, copy) NSString *titlecolor;
@property (nonatomic, readwrite, copy) NSString *isshowtitle;
@property (nonatomic, readwrite, copy) NSString *strcomment;
@property (nonatomic, readwrite, copy) NSString *userguid;
@property (nonatomic, readwrite, copy) NSString *feedback;
@property (nonatomic, readwrite, copy) NSString *ishtml;
@property (nonatomic, readwrite, copy) NSString *templateurl;
@property (nonatomic, readwrite, copy) NSString *secondtitle;
@property (nonatomic, readwrite, copy) NSString *haveheadnews;
@property (nonatomic, readwrite, copy) NSString *fwdw;
@property (nonatomic, readwrite, copy) NSString *fwwh;
@property (nonatomic, readwrite, copy) NSString *ztc;
@property (nonatomic, readwrite, copy) NSString *fwrq;
@property (nonatomic, readwrite, copy) NSString *relinfo;
@property (nonatomic, readwrite, copy) NSString *timingpublishdate;
@property (nonatomic, readwrite, copy) NSString *recommend;
@property (nonatomic, readwrite, copy) NSString *shared;
@property (nonatomic, readwrite, copy) NSString *sourceinfoid;
@property (nonatomic, readwrite, copy) NSString *sourcetype;
@property (nonatomic, readwrite, copy) NSString *ouguid;
@property (nonatomic, readwrite, copy) NSString *titlefontstyle;
@property (nonatomic, readwrite, copy) NSString *infolock;
@property (nonatomic, readwrite, copy) NSString *oucode;
@property (nonatomic, readwrite, copy) NSString *isneedupdateinfodate;
@property (nonatomic, readwrite, copy) NSString *isflow; // 返回1 是置顶
@property (nonatomic, readwrite, copy) NSString *customtitle;
@property (nonatomic, readwrite, copy) NSString *lasteditdate;
@property (nonatomic, readwrite, copy) NSString *overduetype;
@property (nonatomic, readwrite, copy) NSString *shixiao;
@property (nonatomic, readwrite, copy) NSString *isshowweibo;
@property (nonatomic, readwrite, copy) NSString *collection;
@property (nonatomic, readwrite, copy) NSString *imgcategorynum;
@property (nonatomic, readwrite, copy) NSString *urlcategorynum;
@property (nonatomic, readwrite, copy) NSString *flinfoguid;
@property (nonatomic, readwrite, copy) NSString *autostrcomment;
@property (nonatomic, readwrite, copy) NSString *autokeyword;
@property (nonatomic, readwrite, copy) NSString *feedbackDesc;
@property (nonatomic, readwrite, copy) NSString *fullScreen;
@property (nonatomic, readwrite, copy) NSString *oldSysId;
@property (nonatomic, readwrite, copy) NSString *recordstatus;
@property (nonatomic, readwrite, copy) NSString *city;
@property (nonatomic, readwrite, copy) NSString *xiaqucode;
@property (nonatomic, readwrite, copy) NSString *videourl;
@property (nonatomic, readwrite, copy) NSString *imgurl;
@property (nonatomic, readwrite, copy) NSString *xz;
@property (nonatomic, readwrite, copy) NSString *price;
@property (nonatomic, readwrite, copy) NSString *isfree;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *userGuid;
@property (nonatomic, readwrite, copy) NSString *categorynum;
@property (nonatomic, readwrite, copy) NSString *scType;
@property (nonatomic, readwrite, copy) NSString *createtime;
@property (nonatomic, readwrite, copy) NSString *isBuy;
@property (nonatomic, readwrite, copy) NSString *isRead;
@property (nonatomic, readwrite, copy) NSString *isSel;
@property (nonatomic, readwrite, copy) NSString *isPlay;
@property (nonatomic, readwrite, copy) NSString *isTop;
//视频时长
@property (nonatomic, readwrite, copy) NSString *videotime;
//视频作者
@property (nonatomic, readwrite, copy) NSString *author;
//自视频列表中的infoid
@property (nonatomic, readwrite, copy) NSString *videorowguid;
@end

NS_ASSUME_NONNULL_END
