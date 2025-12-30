//
//  WY_MyDormRoomModel.h
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/22.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_MStudentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyDormRoomModel : MHObject
@property (nonatomic , strong) NSString *id;
@property (nonatomic , strong) NSString *userid;
@property (nonatomic , strong) NSString *xsxm;
@property (nonatomic , strong) NSString *kfdm;
@property (nonatomic , strong) NSString *type;
@property (nonatomic , strong) NSString *kcfs;
@property (nonatomic , strong) NSString *useridT;
@property (nonatomic , strong) NSString *tjsj;
@property (nonatomic , strong) NSString *khtpwj;
@property (nonatomic , strong) NSString *url;
@property (nonatomic , strong) NSString *tpmc;
@property (nonatomic , strong) NSString *khfs;
@property (nonatomic , strong) NSString *gxsj;
@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSString *kfmc;
@property (nonatomic , strong) NSString *title;
@property (nonatomic , strong) NSString *gjsid;
@property (nonatomic , strong) NSString *lcss;
@property (nonatomic , strong) NSString *cyzts;
@property (nonatomic , strong) NSString *cyztt;
@property (nonatomic , strong) NSString *khfsgr;
@property (nonatomic , strong) NSString *gjs;
@property (nonatomic , strong) NSString *jjs;
@property (nonatomic , strong) NSString *tssj;
@property (nonatomic , strong) NSString *usernameT;
@property (nonatomic , strong) NSString *usernameS;
@property (nonatomic , strong) NSString *isread; 
@property (nonatomic, readwrite, copy) NSArray <WY_MStudentModel *> *list;


///宿舍情况model
/**图片1*/
@property (nonatomic , strong) NSString *gylhurlo;
@property (nonatomic , strong) NSString *gylhurlt;
@property (nonatomic , strong) NSString *gylhurlth;
/**维度*/
@property (nonatomic , strong) NSString *gylhwd;
/**精度*/
@property (nonatomic , strong) NSString *gylhjd;



@end

NS_ASSUME_NONNULL_END
