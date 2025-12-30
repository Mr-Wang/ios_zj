//
//  WY_MessageModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/24.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MessageModel : MHObject


@property (nonatomic , strong) NSString *id;
@property (nonatomic , strong) NSString *userid;
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
@property (nonatomic , strong) NSMutableArray *list;
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
 
///---- 调寝列表字段///

@property (nonatomic , strong) NSString *cjsj;
@property (nonatomic , strong) NSString *dqzt;
@property (nonatomic , strong) NSString *dqztmc;
@property (nonatomic , strong) NSString *sqsj;
@property (nonatomic , strong) NSString *sqsm;
@property (nonatomic , strong) NSString *sqtype;
 @property (nonatomic , strong) NSString *useridt;


/// ---- 设备维修列表字段///

@property (nonatomic , strong) NSString *hqspsj ;
@property (nonatomic , strong) NSString *hquserid;
@property (nonatomic , strong) NSString *sbbxid;
@property (nonatomic , strong) NSString *sbdm;
@property (nonatomic , strong) NSString *sbmc;
@property (nonatomic , strong) NSString *wtsm;


/// ---- 外出申请列表字段///
@property (nonatomic , strong) NSString *wcsy;
@property (nonatomic , strong) NSString *jssj;
@property (nonatomic , strong) NSString *kssj;
@property (nonatomic , strong) NSString *wcsc;

/// ---- PUSHModel ///
@property (nonatomic , strong) NSString *m_equ_id;
@property (nonatomic , strong) NSString *m_user_phone;
@property (nonatomic , strong) NSString *m_client_id;
@property (nonatomic , strong) NSString *m_app_id;
@property (nonatomic , strong) NSString *m_equipment_flag;
@property (nonatomic , strong) NSString *text;
@property (nonatomic , strong) NSString *cqsj;

@property (nonatomic , strong) NSString *docTitle;
@property (nonatomic , strong) NSString *docUrl;

@end

NS_ASSUME_NONNULL_END
