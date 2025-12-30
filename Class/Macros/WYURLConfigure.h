//
//  MHURLConfigure.h
//  WeChat
// 
//  Created by Mac on 2017/9/10.
//  Copyright © 2017年 Wangyang. All rights reserved.
//
//

#ifndef MHURLConfigure_h
#define MHURLConfigure_h

 /// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
 #define kGtAppId           @"3wbCyDj9bY55HMSErBFqo6"
 #define kGtAppKey          @"u8g5d9s4tk9gbW0ieKGbs9"
 #define kGtAppSecret       @"0yQMkPkDko6AjCcuU81WL3"
 
///// 学习测试服务器
//#define BASE_IP @"http://study-test.capass.cn/"
///// 专家测试服务器
//#define BASE_ZJ_IP @"http://lnwlzj-test.capass.cn/"
//#define BASE_ZJ_IP @"http://52129wu417.qicp.vip:32535/"

/// 陈洪岭
//#define BASE_IP @"http://192.168.0.63:8099/"
///刘健
//#define BASE_IP @"http://192.168.0.137:8099/"
///测试-专家的学习后台0314
//#define BASE_IP  @"https://zjappcs.lnwlzb.com/zjappcs/"
///刘建华
//#define BASE_IP @"http://192.168.1.237:8094/"
///张芷维
//#define BASE_ZJ_IP @"http://192.168.0.94:8046/"
///崔阳
//#define BASE_ZJ_IP @"http://192.168.0.75:8046/"
//#define BASE_ZJ_IP @"http://50759s84h6.qicp.vip/"
///刘林
//#define BASE_ZJ_IP @"http://192.168.1.46:8046/"
///掌上明珠
//#define BASE_ZJ_IP @"http://192.168.0.111:8046/"
//#define BASE_ZJ_IP @"https://z5i2129417.picp.vip/"
///云签章测试用
//#define BASE_ZJ_IP @"http://101.200.38.45:8046/"
///王润志
//#define BASE_ZJ_IP  @"http://192.168.0.169:8046/"
///催
//#define BASE_ZJ_IP  @"http://192.168.0.101:8046/"
///马宏达
//#define BASE_ZJ_IP  @"http://192.168.0.84:8046/"
///李宇超
//#define BASE_ZJ_IP @"http://192.168.0.166:8046/"
///孙强
//#define BASE_ZJ_IP @"http://192.168.1.48:8046/"
///专家测试地址- 刘健用0314
//#define BASE_ZJ_IP @"https://zjcs.lnwlzb.com/zjcsxxzx/"
//#define BASE_IP @"http://192.168.1.88:8099/"
//#define BASE_IP @"http://study.lntb.gov.cn/"
//#define BASE_ZJ_IP @"http://zj.lntb.gov.cn/"
//#define BASE_IP @"https://study.capass.cn/"
/// -------------------------------------------学习正式服务器2------------------------------------------
#define BASE_IP @"https://fgwstudy.lnwlzb.com/"
/// -------------------------\-----------------专家正式服务器------------------------------------------
#define BASE_ZJ_IP @"https://lnwlzj.capass.cn/"
/// ------------------------------------------监管网正式服务器------------------------------------------
#define BASE_JG_IP @"https://www.lntb.gov.cn/xyln/"


 
//oss鉴权生产环境
#define Oss_Url @""

//oss鉴权开发环境
#define Oss_DevUrl @""

///首页
#define getStudySy_HTTP @"webdbInformation/getStudySy"

/// 培训首页
#define getTraEnrolHome_HTTP @"traCourse/getTraEnrolHome"
 ///视频专区和阅读专区列表 --002 是通知公告；
 #define getInformationList_HTTP @"webdbInformation/getInformationList"

///文章详情
 #define getXqbyInfoid_HTTP @"webdbInformation/getXqbyInfoid"

///更新用户信息
#define updateUserInfo_HTTP @"huiyuanUser/updateUserInfo"

///查询用户所属企业
#define getCompanyListByID_HTTP @"search/getCompanyListByID"

///用户更新企业信息
#define updateDanWeiInfo_HTTP @"huiyuanUser/updateDanWeiInfo"

///培训课程分类列表
#define getTraCourseListFromHome_HTTP @"traCourse/getTraCourseListFromHome"

///课程详情页
#define getTraCourseDetail_HTTP @"traCourse/getTraCourseDetail"

///获取企业人员列表
#define getCompanyPersonLists_HTTP @"search/getCompanyPersonLists"

///获取地址列表
#define getUserAddressList @"spaddress/getUserAddressList"
///报名提交接口
#define traEnrolGenerate_HTTP  @"traCourse/traEnrolGenerate"
/// 订单支付
#define onlinepay_HTTP @"pay/onlinepay"
/// 订单支付-通联
#define allinPay_HTTP @"pay/allinPay"

/// 支付成功回调
#define backonlinepay_HTTP @"product/onlinepay"

///我的课程-列表
#define traEnrolList_HTTP @"traCourse/traEnrolList"

///课程订单详情页
#define traEnrolDetail_HTTP @"traCourse/traEnrolDetail"

///电子发票列表
#define getInvoiceList_HTTP @"sporderinvoice/getInvoiceList"

///电子发票详情
#define getInvoiceDetail_HTTP @"sporderinvoice/getInvoiceDetail"

///查询用户积分
#define getXxJf_HTTP @"webdbInformation/getXxJf"

/// 通过邀请码观看直播
#define checkauthCode_HTTP @"webdbInformation/checkauthCode"

///考核首页
#define getExamHome_HTTP @"tExamScore/getExamHome"

///自测开始考试 -获取考试题
#define getQuestionList_HTTP @"tExamScore/getQuestionList"

///正式考试- 获取考试题
#define getRealQuestionList_HTTP  @"tExamScore/getRealQuestionList"
/// 自测-个人历史
#define getPersonOrder_HTTP  @"tExamScore/getPersonOrder"

/// 自测-企业历史
#define getPersonOfUnitOrder_HTTP @"tExamScore/getPersonOfUnitOrder"

/// 试题回顾
#define getEaxmMX_HTTP @"tExamScore/getEaxmMX"

///重置试题
#define resetExam_HTTP @"tExamScore/resetExam"

///提交考试内容 - 自测
#define commitEaxm_HTTP @"tExamScore/commitEaxm"

///提交考试内容 - 真实
#define commitRealEaxm_HTTP @"tExamScore/commitRealEaxm"

///获取正式考试列表
#define  getExamList_HTTP @"huiyuanUser/getExam"

///判断考试能否进行
#define getIsexam_HTTP @"huiyuanUser/getIsexam"

///获取报名用户信息
#define getrzxx_HTTP @"huiyuanUser/getrzxx"

///报名认证 -提交
#define smrzxx_HTTP  @"huiyuanUser/smrzxx"

///提交考试人脸信息内容(真实考试)
#define checkface_HTTP  @"tExamScore/checkface"

///收藏功能
#define insertCollect_HTTP @"webdbInformation/insertCollect"

///阅读文章得积分
#define insetIntegral_HTTP @"webdbInformation/insetIntegral"

///收藏列表
#define getCollect_HTTP @"webdbInformation/getCollect"

///获取上课限制人数
#define selectDanweiguid_HTTP  @"traCourse/selectDanweiguid"

/// 留言板列表
#define getTrainmessage_HTTP @"tTrainmessage/getTrainmessage"

///添加留言
#define insetTTrainmessage_HTTP @"tTrainmessage/insetTTrainmessage"

///消息列表
#define getTslb_HTTP @"webdbInformation/getTslb"
///消息详情
#define updateTslb_HTTP @"webdbInformation/updateTslb"

///添加地址
#define addUserAddress_HTTP @"spaddress/addUserAddress"
///修改地址
#define updateUserAddress_HTTP @"spaddress/updateUserAddress"
///删除地址
#define deleteAddress_HTTP @"spaddress/deleteAddress"
/// 上传文件
#define UPLOADTP_HTTP @"huiyuanUser/uploadavatar"

///type图片类型（1 学习  2培训 3考试  4 进入页）
#define getTpUrl_HTTP @"webdbInformation/getTpUrl"

///首页热搜词
#define getUserkey_HTTP @"webdbInformation/getUserkey"
///pdfShow
#define getpdf_HTTP @"tExamScore/getpdf"
///删除pdf
#define deletePDF_HTTP @"traCourse/deletePDF"
///视频列表
#define getInformationVideoList_HTTP @"webdbInformation/getInformationVideoList"
///企业人员所有积分（只有企业主能看）
#define getQyryJflb_HTTP @"webdbInformation/getQyryJflb"

//出题
#define addQuestion_HTTP @"tQuestion/addQuestion"
//修改题目
#define updateQuestion_HTTP @"tQuestion/updateQuestion"
// 题目列表
#define gettQuestionList_HTTP @"tQuestion/getQuestionList"
///审核题目
#define checkQuestion_HTTP @"tQuestion/checkQuestion"
///获取是否为代理用户
#define dlPerson_HTTP @"sys/login/dlPerson"
/// 余额充值列表
#define appPrice_HTTP @"tAppCoin/getPriceList"
 ///获取余额接口
#define getAppCoin_HTTP @"tAppCoin/getAppCoin"

 ///默认余额列表
#define getdefaultPriceList_HTTP @"tAppCoin/getdefaultPriceList"
/// 充值余额
#define modifyAppCoin_HTTP @"tAppCoin/modifyAppCoin"

 /// 余额详情
 #define getAppCoinDetail_HTTP  @"tAppCoin/getAppCoinDetail"

///余额支付
#define appCoinpay_HTTP @"product/appCoinpay"

/// 专票附件上传
#define uploadInvoice_HTTP @"product/uploadInvoice"

///会员详情页
#define getOpenVIPHome_HTTP @"huiyuanVipXx/getOpenVIPHome"



/**专家 -BaseURL */

///实名认证接口
#define ZJsmrzxx_HTTP @"bidevaluation/smrzxx"
///检查该人员是否在监管库
#define checkinjianguan_HTTP @"bidevaluation/checkinjianguan"
///评标通知接口
#define getBidNoticeList_HTTP @"bidevaluation/getBidNoticeList"
 ///评标专家首页接口
 #define getzjDefaultGetDefault_HTTP @"zjDefault/getDefault"
///绑定pushID
#define ADDPUSHCLIENTEQUIPMENT @"pushClientEquipment/addPushClientEquipment"
///专家上传图片
#define EuploadFile_HTTP @"expert/uploadFile"
///选择专业
 #define getProfession_HTTP  @"expert/getProfession"

///身份证 OCR
 #define zj_recognition_idcard_HTTP @"recognition/idcard"

///选择老专业  参数 pcode   第一级下拉传空字符串
 #define expertGetSysIndustriesTypeSecondList_HTTP  @"expert/getSysIndustriesTypeSecondList"




///获取专家信息
#define getExpertMessage_HTTP  @"expert/getExpertMessage"
///获取无专业类别专家信息
#define getExpertMessageOfAll_HTTP  @"expert/getExpertMessageOfAll"


///提交专家信息
#define  updateZjData_HTTP @"expert/updateZjData"
///完善信息审核状态
#define expertGetExpertList_HTTP @"expert/getExpertList"
///获取专家完善信息状态
#define expertGetUserHasCompleteStatus_HTTP @"expert/getUserHasCompleteStatus"
///获取专家锁定状态
#define expertIsLocked_HTTP @"expert/isLocked"
///获取专家信用
#define expertGetExpertPenalty_HTTP @"expert/getExpertPenalty"
///专家请假获取电话
#define expertGetLeavePhone_HTTP @"expert/getLeavePhone"
 ///一天扫一次脸 -data 0 不需要扫脸，1需要扫脸
 #define bidevaluationSmrzxxIsBelow_HTTP @"bidevaluation/smrzxxIsBelow"
///签到接口
#define expertDecrypt_HTTP @"expert/signIn"
 ///签到判断时间、距离接口
 #define expertDistance_HTTP @"expert/distance"
 ///扫脸登录
 #define faceLogin_HTTP @"sys/face/login"

/// 登陆
#define LOGINHTTP  @"sys/login/restful"
/// 退出登陆
#define LOGOUTHTTP  @"sys/logout"
/// 注册获取验证码
#define ZC_SEND_SHORT_HTTP @"pushClientEquipment/sendShortMessageZc"
/// 找回密码获取验证码
#define LOSTPWD_SEND_SHORT_HTTP @"pushClientEquipment/sendShortMessage"
///修改密码
#define UPDATEPASSWORD_HTTP @"huiyuanUser/updatePassword"
///重置密码
#define RESETPWD_HTTP @"huiyuanUser/resetPassword"
/// 注册
#define ZC_HTTP @"sys/login/register"
///获取专家是否通过考试
#define expert_getExpertPass_HTTP @"expert/getExpertPass"

///获取专家完善信息身份列表
#define expert_getExpertIdentity_HTTP @"expert/getExpertIdentity"

///获取专家-专业列表
#define getWaitExtractProfession_HTTP @"expert/getWaitExtractProfession"

///专家专业更多- 列表
#define getProfessionHistory_HTTP @"expert/getProfessionHistory"

///获取专家完善的信息(新-2020-11-03)
#define expert_getExpertInfo_HTTP  @"expert/getExpertInfo"

///网联-获取专家证书前置条件 0 成功、1失败、2未生成证书
#define wl_addQuestion_getZJStatus_HTTP  @"tExamScore/getZJStatus"

///网联-上传头像生成证书
#define wl_tExamScore_CreateZJcert_HTTP   @"tExamScore/getZJcertNew"

///专家-获取职称等级
#define zj_expert_getJobTitle_HTTP @"expert/getJobTitle"

///专家-添加评论
#define zj_insertRate_HTTP @"expert/insertRate"
///专家 - 我的评价列表
#define zj_getExpertRateList_HTTP @"expert/getExpertRateList"

///专家 - 查看代理对我的评价
#define zj_getExpertEvaluate_HTTP @"expert/getExpertEvaluate"

///专家 - 获取我的评价详情
#define zj_getExpertRateDetail_HTTP @"expert/getExpertRateDetail"
///-专家 - 获取评价详情 新的
#define zj_bidevaluationGetExpertEvaluate_HTTP @"bidevaluation/getExpertEvaluate"
 
///专家 - 提交申诉
#define zj_expertReconsider_HTTP @"expert/expertReconsider"

///专家 - 申诉详情
#define zj_getReconsiderDetail_HTTP @"expert/getReconsiderDetail"

/// 专家- 推送列表
#define zj_getTsList_HTTP @"expert/getTsList"
/// 专家- CA生成申请书
#define zj_caCreateCa_HTTP @"ca/createCa"
/// 专家-CA - 获取用户基本信息
#define zj_sysGetInfo_HTTP @"sys/getInfo"
/// 专家- CA签名申请书
#define zj_caRequestCa_HTTP @"ca/requestCa"
/// 专家-CA提交订单接口
#define zj_createDD_HTTP @"ca/createDD"
/// 专家-CA订单列表接口
#define zj_getMyDeal_HTTP @"ca/getMyDeal"
/// 专家-CA订单详情接口
#define zj_getMyDealInfo_HTTP @"ca/getMyDealInfo"
 /// 专家 - CA确认收货
#define zj_CAreceipt_HTTP @"ca/receipt"
/// 专家 -获取的CA申请状态
#define zj_CAGetCaStatus_HTTP  @"ca/getCaStatus"
/// 专家 -删除CA订单
#define zj_CAdeleteDD_HTTP  @"ca/deleteDD"
/// 专家-CA补办接口
#define zj_createBB_HTTP @"ca/createBB"
/// 专家- CA补办签名申请书
#define zj_caRequestBB_HTTP @"ca/requestBB"
/// 专家-CA补办-下单接口
#define zj_createBBDD_HTTP @"ca/createBBDD"
///专家-CA查询-是否有补办未完结状态；
#define zj_getBBStatus_HTTP  @"ca/getBBStatus"
/// 专家-是否能获取专家行动轨迹
#define zj_getZjAddressesStatus_HTTP  @"expert/getZjAddressesStatus"
/// 专家-收集专家行动轨迹坐标
#define zj_getZjAddresses_HTTP  @"expert/getZjAddresses"
/// 专家-文档列表
#define zj_getBookList_HTTP @"expert/getBookList"
/// 学习 - 转换HTML
#define delHTMLTag_HTTP @"tExamScore/delHTMLTag"
/// 专家获取管理员身份； -code 0是管理员
#define zj_sysGetAdmin @"sys/getAdmin"

/// -监管- 创建咨询投诉
#define jg_expertQuestionCreateQuestion_HTTP @"expertQuestion/createQuestion"
/// -监管- 创建咨询投诉 - 提交
#define jg_expertQuestionAnswerQuestion_HTTP @"expertQuestion/answerQuestion"
/// -监管- 创建咨询投诉 - 上传图片
#define jg_expertQuestionUpload_HTTP @"expertQuestion/upload"
/// -监管- 创建咨询投诉 - 获取我的提问列表
#define jg_expertQuestionGetMyQuestion_HTTP @"expertQuestion/getMyQuestionNew"
/// -监管- 创建咨询投诉 - 管理员获取提问列表
#define jg_expertQuestionGetQuestionForAdmin_HTTP @"expertQuestion/getQuestionForAdminNew"
/// -监管- 获取城市列表
#define jg_regionCityByLN_HTTP @"region/cityByLN"
///-监管- 咨询投诉评分 - body参数 回复的id 评分 anRate
#define jg_expertQuestionAnswerRate_HTTP  @"expertQuestion/answerRate"
/// -专家- 回避单位列表
#define zj_expertGetActiveAvoidanceCompany_HTTP @"expert/getActiveAvoidanceCompany"
/// -专家 - 添加回避单位
#define zj_expertUpdateActiveAvoidanceCompany_HTTP @"expert/updateActiveAvoidanceCompany"

/// -专家 - 删除回避单位
#define zj_expertDeleteActiveAvoidanceCompany_HTTP @"expert/deleteActiveAvoidanceCompany"

/// - 专家 - 专业buff
#define zj_expertGetExpertTags_HTTP @"expert/getExpertTag"
///虚拟中间号- AB绑定
#define zj_HostRecordPhone_HTTP @"host/recordPhone"
///专家证书 - 生成确认接口
#define xx_InsertZJCert @"tExamScore/insertZJcert"
///专家银行卡- 获取
#define zj_getExpertBank_HTTP @"expert/getExpertBank"
///专家银行卡输入银行卡号后 自动验证
#define zj_expert_bank_getBank_HTTP @"expert/bank/getBank"
///专家-添加银行卡接口
#define zj_perfectBank_HTTP @"expert/perfectBank"
///专家- 查询是是不是社会专家，社会紫（超龄）1、社会蓝（甲方）2
#define zj_expert_getExpertIsMind_HTTP @"expert/getExpertIsMind"
///专家- 新专家征集报名
#define zj_expertTouristChangeExpert_HTTP @"expert/touristChangeExpert"
///-专家- 申请注销账号
#define zj_userlogout_HTTP @"sys/user/logout"

///-专家- 获取 是否新入库专家  0 是  1 不是
#define zj_expertgetExpertIsNew_HTTP @"expert/getExpertIsNew"
///-专家- 修改专家库手机号
#define zj_expertupdatePhone_HTTP @"expert/updatePhone"
/// - 专家- 修改手机号 -发送验证码
#define zj_expertsendUpdateMessage_HTTP @"expert/sendUpdateMessage"

/// - 专家- 获取专家资格证书照片
#define zj_getCertificates_HTTP @"expert/getCertificates"
/// - 专家- 上传专家资格证书照片
#define zj_perfectCertificates_HTTP @"expert/perfectCertificates"
/// -专家-上传
#define zj_ca_signGot_HTTP @"ca/signGot"

/// -专家保存-中共党员身份 和 签字的接口    2022-04-08 18:19:26
#define zj_getUserSignature_HTTP @"huiyuanUser/getUserSignature"
/// -专家劳务报酬结算列表
#define zj_getBidEvaluationFeeList_HTTP @"bidevaluation/getBidEvaluationFeeList"

/// -专家评标协议签字-协议没有签字  bidSectionCodes标段名称  idcardnum 身份号   UserGuid 用户id
#define zj_requestReview_HTTP  @"bidevaluation/signinSignature"

/// -专家评标协议签字-协议带签字   bidSectionCodes标段名称  idcardnum 身份号   UserGuid 用户id   userSignature  签字url
#define zj_requestReviewSignature_HTTP  @"bidevaluation/signinSignatureNew"

/// -专家费详情
#define zj_getBidEvaluationFeeDetailed_HTTP @"bidevaluation/getBidEvaluationFeeDetailed"
/// - 专家费结算记录
#define zj_getbidEvaluationFeeRecord_HTTP @"bidevaluation/getbidEvaluationFeeRecord"
/// -专家增加费用异议
#define zj_getExpertDetailed_HTTP @"bidevaluation/getExpertDetailed"
/// 结算签字协议
#define zj_tradingSignature_HTTP @"bidevaluation/tradingSignature"
/// 结算未签字协议
#define zj_tradingNotSignature_HTTP @"bidevaluation/tradingNotSignature"
/// 提交结算
#define zj_tradingSignatureConfirm_HTTP @"bidevaluation/tradingSignatureConfirm"
//#define zj_requestReviewSignature_HTTP  @"bidevaluation/requestReviewSignature"

/// - 专家办理云签章 - 获取云签章类型
#define zj_getCloudSignatureType_HTTP @"ca/getCloudSignatureType"
/// - 专家办理云签章 - 获取云签章介绍
#define zj_handleCloudSignatureIntroduce_HTTP @"ca/handleCloudSignatureIntroduce"

/// - 专家办理云签章 -生成订单
#define zj_handleCloudSignature_HTTP @"ca/handleCloudSignature"

//getCloudSignaturePrice(String manufacturer,String validityPeriod)
/// - 专家办理云签章 - 查钱
#define zj_getCloudSignaturePrice_HTTP @"ca/getCloudSignaturePrice"
/// -专家办理云签章列表
#define zj_getCloudSignatureList_HTTP @"ca/getCloudSignatureList"
/// -专家云签章订单详情
#define zj_getCloudSignature_HTTP @"ca/getCloudSignature"
/// -专家云签章取消订单
#define zj_cancelCloudSignature_HTTP @"ca/cancelCloudSignature"
/// -专家证书、云签章获取订单状态
#define zj_canableToHandle_HTTP @"ca/canableToHandle"
/// -专家- 云签章 修改签名
#define zj_updateSignature_HTTP @"ca/updateSignature"
///取消结算
#define zj_tradingCancelSignature_HTTP @"bidevaluation/tradingCancelSignature"
///专家字典表
#define zj_dictionary_HTTP @"dictionary"
///添加申诉
#define zj_appealExpertEvaluate_HTTP @"bidevaluation/appealExpertEvaluate"
///申诉列表
#define zj_getAppealList_HTTP @"bidevaluation/getAppealList"
///考评记录表
#define zj_getExpertEvaluateTable_HTTP @"bidevaluation/getExpertEvaluateTable"
///申诉详情
#define zj_getExpertEvaluateById_HTTP @"bidevaluation/getExpertEvaluateById"
///首页消息未读数
#define zj_getExpertEvaluateUnReadCount_HTTP @"bidevaluation/getExpertEvaluateUnReadCount"
///年度评价首页
#define zj_evaluate_HTTP @"bidevaluation/year/evaluate"
///奖励加分事项类型代码表
#define zj_rewardCode_HTTP @"bidevaluation/rewardCode"
///奖励加分列表
#define zj_rewardApplyList_HTTP @"bidevaluation/rewardApplyList"
///申请奖励加分
#define zj_rewardApply_HTTP @"bidevaluation/rewardApply"
///其他扣分
#define zj_getOtherPoints_HTTP @"bidevaluation/getOtherPoints"
///违法行为
#define zj_getIllegalIdcard_HTTP @"bidevaluation/getIllegalIdcard"
///总体参评得分
#define zj_getCallResult_HTTP @"bidevaluation/getCallResult"
///一键请假
#define zj_leave_HTTP @"bidevaluation/leave"
///苹果支付-云签章
#define zj_payiosPay_HTTP @"pay/iosPay"
///开关接口
#define zj_dictionaryGetCode_HTTP @"dictionary/getCode"
///同步专家库
#define zj_syncExpertData_HTTP @"expert/syncExpertData"
///专家修改专业地区
#define zj_updateCity_HTTP @"expert/updateCity"
///专家修改地区 审核记录
#define zj_getApproval_HTTP @"expert/approvalRecord"
///专家修改地区详情页
#define zj_updateDetail_HTTP @"expert/selectDetailById"
///云签章-临时项目
#define zj_handleProjectCloudSignature_HTTP @"ca/handleProjectCloudSignature"
///设置主评专业
#define zj_setMainEvaluationMajor_HTTP @"expert/setMainEvaluationMajor"
///申请国家节点
#define zj_insertNationalNodesOrNewMechanism_HTTP @"expert/insertNationalNodesOrNewMechanism"
///申请国家节点详情页；
#define zj_getExpertMainEvaluationInformation_HTTP @"expert/getExpertMainEvaluationInformation"
///国家节点库及新机制审核列表
#define zj_getExpertMainEvaluationList_HTTP @"expert/getExpertMainEvaluationList"

/// 查询getCommitmentEleNew
#define zj_getCommitmentEleNew_HTTP @"expert/getCommitmentEleNew"
/// 修改commitmentEleNew
#define zj_updCommitmentEleNew_HTTP @"expert/updCommitmentEleNew"

/// 首页提示
#define zj_getCityExportUpd_HTTP  @"expert/getCityExportUpd"
///看视频轮询
#define addVideoDetail_HTTP @"webdbInformation/addVideoDetail"
///评价详情接口
#define getTrainmessagenew_HTTP @"tTrainmessage/getTrainmessagenew"
///专家请假
#define zj_expertLeaveResponse_HTTP @"expert/expertLeaveResponse"
#endif /* MHURLConfigure_h */


