//
//  WY_SendEnrolmentMessageModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_TraEnrolPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SendEnrolmentMessageModel : MHObject
 
@property (nonatomic, readwrite, copy) NSArray <WY_TraEnrolPersonModel *> *traEnrolPersonBeans;

//        "islingqu": "是否领取",
//            "invoiceoftype": "发票类型",
//            "isInvoice": "是否开发票",
//
//            "Amount": "订单总金额",
//            "InvoiceBankNo": "发票开户行账号",
//            "CGRDanWeiName": "测试2",
//            "InvoiceEmail": "发票Email",
//            "InvoiceMobile": "发票联系方式",
//            "InvoiceAddress": "发票联系地址",
//
//            "InvoiceType": "企业",
//            "InvoiceName": "发票抬头",
//            "TaxpayerNo": "纳税人识别号",
//            "Receiver": "收货人姓名",
//            "Mobile": "联系手机",
//            "InvoiceBankName": "发票开户行"
@property (nonatomic , strong) NSString * OrderNo;
@property (nonatomic , strong) NSString *  Amount;
@property (nonatomic , strong) NSString * price;
@property (nonatomic , strong) NSString * serviceType;
@property (nonatomic , strong) NSString * adviceType;
@property (nonatomic , strong) NSString * CGRUserName;
@property (nonatomic , strong) NSString *  InvoiceType; //1.公司。2.个人
@property (nonatomic) BOOL isInvoice;
@property (nonatomic , strong) NSString *  InvoiceBankNo;
@property (nonatomic , strong) NSString *  InvoiceEmail;
@property (nonatomic , strong) NSString *  InvoiceMobile;
@property (nonatomic , strong) NSString *  invoiceoftype;//1.电子发票、2.纸质发票、3.纸质专票
@property (nonatomic , strong) NSString *  InvoiceName;
@property (nonatomic , strong) NSString *  TaxpayerNo;
@property (nonatomic , strong) NSString *  InvoiceBankName;
@property (nonatomic , strong) NSString *  zengzhishuiurl;
@property (nonatomic , strong) NSString *  InvoiceAddress;
@property (nonatomic , strong) NSString *  lxdh;
@property (nonatomic , strong) NSString *  fpAddress;
@property (nonatomic , strong) NSString *  fpdh;
@property (nonatomic , strong) NSString *  fpry;
@property (nonatomic , strong) NSString *  fpzt;
//1 领取 - 2 邮寄
@property (nonatomic , strong) NSString *  islingqu;

//+ (NSDictionary *)modelCustomPropertyMapper {
//    NSDictionary *dic=@{@"InvoiceEmail" :@"Email",@"InvoiceMobile":@"GMFDH",@"InvoiceAddress":@"XSFDZ",@"InvoiceBankNo":@"XSFYHMC",@"InvoiceBankName":@"XSFYHZH"};
//    return dic;
//}
@property (nonatomic , strong) NSString *Email;
@property (nonatomic , strong) NSString *GMFDH;
@property (nonatomic , strong) NSString *XSFDZ;
@property (nonatomic , strong) NSString *XSFYHMC;
@property (nonatomic , strong) NSString *XSFYHZH;
@property (nonatomic , strong) NSString *PdfUrl;
@end

NS_ASSUME_NONNULL_END
