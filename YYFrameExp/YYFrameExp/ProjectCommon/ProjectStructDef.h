//
//  ProjectStructDef.h
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#ifndef jimao_ProjectStructDef_h
#define jimao_ProjectStructDef_h

/*
 系统配置的积分来源编码值
 1: sina
 2: tencent
 3: sms
 4: wechat_friends
 5: wechat
 6: renren
 7: yixin
 8:yixin_fir
 9:QQ
 10:qq_Zone
 */
typedef NS_ENUM(NSUInteger, ShareSocialType) {
    ShareSocialTypeSina = 1,
    ShareSocialTypeTencent = 2,
    ShareSocialTypeSMS = 3,
    ShareSocialTypeWechat_fri = 4,
    ShareSocialTypeWechat = 5,
    ShareSocialTypeRenren = 6,
    ShareSocialTypeYinxin = 7,
    ShareSocialTypeYinxin_fri = 8,
    ShareSocialTypeQQ = 9,
    ShareSocialTypeQQ_zone = 10,
};
/*
系统配置的积分来源编码值
201: 本应用分享
202: 内容分享
203: 活动分享
204: 广告位分享
205: 商品分享
206: 任务分享
207: 邀请好友分享
 */
typedef NS_ENUM(NSUInteger, ShareSourceCode) {
    ShareSourceCodeThisApp = 201,
    ShareSourceCodeContent = 202,
    ShareSourceCodeActive = 203,
//    ShareSourceCodeAd = 204,
//    ShareSourceCodeShop = 205,
//    ShareSourceCodeTask = 206,
    ShareSourceCodeInviteFriend = 207,
//    ShareSourceCodeGame = 208,
    ShareSourceCodeLuckGambling = 221,
    ShareSourceCodeFlowArticle = 222,
};

typedef NS_ENUM(NSUInteger, EarnBeanFavoriteType) {
    EarnBeanFavoriteTypeApp = 6,
    EarnBeanFavoriteTypeFlow = 2,
    EarnBeanFavoriteTypeGift = 3,
};

typedef NS_ENUM(NSUInteger, AdType) {
    AdTypeSelf = 1,
    AdTypeDomo = 2,
};

typedef NS_ENUM(NSUInteger, AdPlaceType) {
    AdPlaceTypeLoadPage = 1,
    AdPlaceTypeHomeBanner = 2,
    AdPlaceTypeHomePop = 3,
    AdPlaceTypeFlowCharge = 4,
    AdPlaceTypeFlowCard = 5,
    
    // unused
//    AdPlaceTypeCommonWeal = 6,
//    AdPlaceTypeChargeFlow = 7,
};
//任务奖励类型

typedef NS_ENUM(NSUInteger, ScoreType) {
    ScoreTypeFood = 1,
    ScoreTypeFlow = 2,
    ScoreTypeExp = 3,
    ScoreTypeUnkown = 0,
};

//任务类型
typedef NS_ENUM(NSUInteger, ProTaskType) {
    ProTaskTypeUnkown = 0,
    ProTaskTypeUndo = 1,
    ProTaskTypeDone = 2,
    ProTaskTypeExpi = 99,
    ProTaskTypeUnLing = 111,
};

typedef NS_ENUM(NSInteger, TaskType) {
    TaskTypePic = 1001,
    TaskTypeVedio = 1002,
    TaskTypeApp = 2001,
    TaskTypeGame = 2002,
    TaskTypeWen = 3001,
    TaskTypeBao = 3002,
    TaskTypeShare = 4001,
    TaskTypeAttention = 4002,
    TaskTypeFanli = 5001,
};

//任务状态
//1:正常未领 10:已领取并在进行中的任务 20:已领取并完成的任务 30:已领取并已领钱的任务
 
typedef NS_ENUM(NSUInteger, TaskStatus) {
    TaskStatusUnGet = 1,
    TaskStatusGotDoing = 10,
    TaskStatusGotDone = 20,
    TaskStatusGotGot = 30,
    TaskStatusExpired = 99,
   };

//支付方式
typedef NS_ENUM(NSUInteger, PaymentType) {
    PayTypeApi = 1,
    PayTypeWX  = 2,
};

//运营商
typedef NS_ENUM(NSUInteger, operatorType) {
    operatorTypeDianXin = 0,
    operatorTypeLianTong = 1,
    operatorTypeYidong = 2,
};
//pwd
typedef NS_ENUM(NSUInteger, PwdStep) {
    pwdStepNo = 0,
    pwdStepOne = 1,
    
    pwdStepAuthCode = 2,
    pwdStepInputPwd = 3,
    
    pwdStepTwo = 4,
};
typedef NS_ENUM(NSUInteger, RegisterType) {
    RegisterTypeRegisterForPhone = 0,
    RegisterTypeRegisterForMail = 1,
    RegisterTypeFindForPhone = 2,
    RegisterTypeFindForMail = 3,
    RegisterTypeForBandPhone = 4,
    RegisterTypeForBandMail = 5,
    RegisterTypeForEditPhone = 6,
    RegisterTypeForEditMail = 7,
    RegisterTypeForChangePwd = 8,
};

//2.0.3版
//我的订单搜索类型
//-1:全部订单,按下单时间降序
//0:待支付订单,按下单时间降序
//1:已支付订单,按支付时间降序
//2:已发货订单,按发化时间降序
//该属性不传时,默认为-1


/*2.0.4版
 -1:全部订单,按下单时间降序
 0:待兑换订单,按下单时间降序
 1:待发货订单,按支付时间降序
 2:交易成功订单,按发化时间降序
 3:交易失败订单,按发化时间降序
 该属性不传时,默认为-1
 */
typedef NS_ENUM(NSInteger, MyOrderType) {
    myOrderAllOrder = -1,
    myOrderNoPayOrder = 0,
    myOrderNoShippOrder = 1,
    myOrderHasSuccessOrder = 2,
    myOrderFailureOrder=20,
};


//1:进行中的任务
//2:往期任务
//该属性不传,默认为1
typedef NS_ENUM(NSUInteger, MyActivityType) {
    MyActivityTypeIn = 1,
    MyActivityTypeBefore = 2,
};

//我的任务状态
typedef NS_ENUM(NSUInteger, MyTaskStatus) {
    MyTaskStatusIng = 10,
    MyTaskStatusDone = 20,
    MyTaskStatusGetDone = 30,
    MyTaskStatusExpired = 99,
};
//搜索任务状态
typedef NS_ENUM(NSUInteger, SearchTaskStatus) {
    SearchTaskStatusIng = 1,
    SearchTaskStatusDone = 2,
    SearchTaskStatusExpired = 3,
};
//我的资料类型
typedef NS_ENUM(NSUInteger, MyMsg) {
    MyMsgNick = 1,
    MyMsgDate = 2,
    MyMsgSex = 3,
    MyMsgAddress = 4,
    MyMsgAlipy = 5,
    MyMsgQQ = 6,
    MyMsgWX = 7,
    MyMSgEmail = 8,
    MyMsgWork = 9,
};

typedef NS_ENUM(NSUInteger,GoodsListSeachType)
{
    GoodsListSeachByPeople = 1,
    GoodsListSeachByNew = 2,
    GoodsListSeachByPrice = 3,
};


/**
 *  订单跳转类型
 */
typedef NS_ENUM(NSUInteger,JumpTypeFrom){
    /**
     *  从商品详情跳转
     */
    JumpTypeFromShopDetail = 1,
    /**
     *  从订单详情跳转
     */
    JumpTypeFromMyOrder = 2,
    /**
     *  从充流量界面跳转
     */
    JumpTypeFromChargeFlow = 3,
    /**
     *  充流量跳转
     */
    jumpTypeFromChargePhone = 4,
};


/**
 *  订单类型
 */
typedef NS_ENUM(NSUInteger,OrderTypeStruct){
    /**
     *  自有订单
     */
    OrderTypeStructMine = 0,
    /**
     *  赠送订单
     */
    OrderTypeStructFriend = 1,
};


/**
 *  订单来源
 */
typedef NS_ENUM(NSUInteger,SourceFromStruct){

    SourceFromStructShop = 1,

    SourceFromStructCharge = 2, //充值
};

/**
 *  商品类型
 */
typedef NS_ENUM(NSInteger,DummyTypeStruct){
    /**
     *   实物商品
     */
    DummyTypeStructPhysical = 0,
    /**
     *   流量商品
     */
    DummyTypeStructFlow = 1,
    //话费商品
    DummyTypeStructPhoneFees = 2,
};


//二维码跳转
typedef NS_OPTIONS(NSUInteger, QR_Type) {
    QR_Type_HTTP      = 1 << 0,//0001
    QR_Type_PAGE      = 1 << 1,//0010
    QR_Type_CUSTOM    = 1 << 2,//0100
    QR_Type_FLOWCARD  = 1 << 3,//1000
   
};
/**
 *  上传图片类型
 */
typedef NS_ENUM(NSUInteger,UploadImgType){
    /**
     *   临时
     */
    UploadImgType_TMP = 0x1001,
    /**
     *   头像
     */
    UploadImgType_HEADER = 0x1002,

};



/**
 *  报名类别 1-培训报名 2-活动报名
 */
typedef NS_ENUM(NSUInteger,SignUpStruct){
    /**
     *  培训
     */
   SignUpStructTrain = 1,
    /**
     *   报名
     */
    SignUpStructSign = 2,
    
};




/**
 * 验证码类型 1.注册 2.重置密码 3.修改密码 4.手机号绑定
 */
typedef NS_ENUM(NSUInteger,VcodeTypeStruct){
    /**
     *  注册
     */
    VcodeTypeStructRegister = 1,
    VcodeTypeStructReSetMima= 2,
    VcodeTypeStructChange  = 3,
    VcodeTypeStructBind = 4,
    
};




/**
 *  美单分类定义 1.活动妆 2.影视妆 3.婚庆妆 4.其它
 */
typedef NS_ENUM(NSUInteger,MeiDanCategoryType){
    MeiDanCategoryTypeAll = 0,
    MeiDanCategoryTypeActive = 1,
    MeiDanCategoryTypeYingShi= 2,
    MeiDanCategoryTypeMerry = 3,
    MeiDanCategoryTypeOther = 99,
};


/**
 *  美单状态定义 0.未接单 1.待确认  2.已确认 5.已退回 3.已结单 4.已撤单 6.已取消
 */
typedef NS_ENUM(NSUInteger,MeiDanStatuType){
    MeiDanStatuTypeNotGet = 0, //未接单
    MeiDanStatuTypeWillGet= 1, // 待确认
    MeiDanStatuTypeHasGet  = 2, //已确认
    MeiDanStatuTypeBack  = 5, //已退回
    MeiDanStatuTypeEnd  = 3, //已结单
    MeiDanStatuTypeUndo  = 4, //已撤单
    MeiDanStatuTypeCancel = 6,//已取消
};

/**
 *	美单服务费类型定义
 */
typedef NS_ENUM(NSUInteger,MeiDanAddFreeType){
    MeiDanAddFreeTypeAddress = 1, //异地费
    MeiDanAddFreeTypeAddTime= 2, // 加时费
    MeiDanAddFreeTypeRoad  = 3, //路费
};


#endif
