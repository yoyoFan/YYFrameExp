//
//  ConstansMacro.h
//  jimao
//
//  Created by Dongle Su on 14-11-24.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#ifndef jimao_ConstansMacro_h
#define jimao_ConstansMacro_h

// constans
#define kClientType 4
#define kInternalVersion @"1.0.2" //可劲美版本号

#define PLACEHODER_BANNER_IMAGE [UIImage imageNamed:@"placeholderBanner"]
#define PLACEHODER_SQUARE_IMAGE [UIImage imageNamed:@"placeholderSquare"]
#define PLACEHODER_USER_HEADER_IMAGE [UIImage imageNamed:@"placeHoldTouX"]


#define PlaceHolder_Ad_HomeIMG @"placeholderHomeAd"
#define PlaceHolder_Ad_FlowMainIMG @"placeholderFlowMain"

#define PLACEHODER_HEADER_IMG @"mymsg_header"
#define PLACEHODER_HEADER_USER_CENTER_IMG @"placeHoldTouX"
#define AD_PLACEHODER_IMG_NAME @"placeholderFlowMain"


//// colors
#define BORDER_COLOR [UIColor colorFromHexString:@"#E7E7E7"] //C2线框描边
 #define MAIN_TITLE_COLOR [UIColor colorFromHexString:@"#252525"] //C6 黑色字体
#define DETAIL_COLOR [UIColor colorFromHexString:@"#FBFBFB"] //C7 副标题，正文、主菜单图标
#define MAIN_TINT_COLOR [UIColor colorFromHexString:@"#E44C4C"]     //C4 导航按钮、选中框、主色调
#define TINT_COLOR_HINT [UIColor colorFromHexString:@"#FF9255"]
//
////下面的颜色值尽量不要用了：->
#define TINT_GRAY_COLOR [UIColor colorFromHexString:@"#AFAFAF"] //淡灰色      //C8  灰色字，参与点赞图标
#define DARK_GRAY_COLOR [UIColor colorFromHexString:@"#7A8389"] //深灰色      //C7 副标题，正文、主菜单图标
////<-


//#define TIPS_GREAT_FONT [UIFont systemFontOfSize:14]

#define MAIN_BACK_GROUND_COLOR [UIColor colorFromHexString:@"#F5F5F5"] //C3背景色

//定义颜色
#define ColorC1 [UIColor colorFromHexString:@"#FFFFFF"]
#define ColorC2 [UIColor colorFromHexString:@"#FBFBFB"]
#define ColorC3 [UIColor colorFromHexString:@"#EEEEEE"]
#define ColorC4 [UIColor colorFromHexString:@"#BEBEBE"]
#define ColorC5 [UIColor colorFromHexString:@"#959595"]
#define ColorC6 [UIColor colorFromHexString:@"#252525"]
#define ColorC7 [UIColor colorFromHexString:@"#FF4A83"]
#define ColorC8 [UIColor colorFromHexString:@"#F2326E"]
#define ColorC9 [UIColor colorFromHexString:@"#FFAC02"]
#define ColorC10 [UIColor colorFromHexString:@"#F7A600"]
#define ColorC11 [UIColor colorFromHexString:@"#FDA2BF"]
#define ColorC12 [UIColor colorFromHexString:@"#FE6D9B"]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

//系统字号
#define UIFont16 [UIFont systemFontOfSize:16]
#define UIFont14 [UIFont systemFontOfSize:14]
#define UIFont12 [UIFont systemFontOfSize:12]
#define UIFont10 [UIFont systemFontOfSize:10]

//Cell中间的分割线
#define CellSeperatorHeight 5

#define MAIN_PAGE_FONT IS_LOWER_OR_EQUEL_4_INCH ? [UIFont systemFontOfSize:16] : [UIFont systemFontOfSize:17]
#define MAIN_PAGE_DETAIL_FONT IS_LOWER_OR_EQUEL_4_INCH ? [UIFont systemFontOfSize:12] : [UIFont systemFontOfSize:13]

#define IS_LOWER_OR_EQUEL_4_INCH                   (APP_SCREEN_HEIGHT <= 568.0)
#define IS_IPhone6                                 (APP_SCREEN_WIDTH > 320.0)
// notifications
#define kLoginNotification @"LoginNotification"
#define kLogoutNotification @"LogoutNotification"


#define kFlowTaskDoneNotification @"FlowTaskDoneNotification"

//提交我的资料成功或者提交头像成功
#define kSumintMyMNsgNotification @"UserProfileChangedNotification"

//添加新的地址
#define kAddNewAddressNotification @"AddNewAddressNotification"

//密码位数限制
#define MIN_NUM 6
#define MAX_NUM 20


//分享
#define TipSharePro @"已分享，正在保存..."

//分享、社交圈绑定
#define TipNoShareType @"抱歉，请换个分享方式吧:%@"


//企业文化
#define CULTUREURL_ @"http://www.kejinmei.cn/kjm-wap/culture.html"
//会员认证协议
#define AGREEMENTURL_ @"http://www.kejinmei.cn/kjm-wap/agreement.html"
//注册协议
#define REGISTEREDURL_ @"http://www.kejinmei.cn/kjm-wap/registered.html"
//隐私协议
#define PRIVACYURL_ @"http://www.kejinmei.cn/kjm-wap/privacy.html"

//平台服务协议
#define PlatFormURL_ @"http://www.kejinmei.cn/kjm-wap/platfrom-agrm.html"

//常见问题
#define QUESTIONURL_ @"http://www.kejinmei.cn/kjm-wap/question.html"
//法律援助
#define LAWSAIDURL_ @"http://www.kejinmei.cn/kjm-wap/lawsaid.html"
//美币规范
#define CURRENCYURL_  @"http://www.kejinmei.cn/kjm-wap/currency.html"
//佣金规则
#define COMMISSIONURL_ @"http://www.kejinmei.cn/kjm-wap/commission.html"
//积分规则
#define INTEGRALURL_ @"http://www.kejinmei.cn/kjm-wap/integral.html"
//APP下载页面
#define APP_DOWNLOADURL_ @"http://www.kejinmei.cn/down/"

//分享icon
#define APP_shareIcon_ @"http://www.kejinmei.cn/kjm-wap/share.png"

#define shareDownUrl  [NSURL URLWithString:@"http://www.kejinmei.cn/down/"]
#define shareWapUrl [NSURL URLWithString:@"http://www.kejinmei.cn/down/"]


//公共提示语
#define kTipNoLogin @"当前模块仅对登录用户开放，请登录后重试"
#define kTipNoRenZheng @"当前模块仅对认证用户开放，请认证后重试"
//#define kTipNoLoginAndNoRenZheng @""




#endif
