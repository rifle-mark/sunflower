//
//  SerpverProxy.h
//  Sunflower
//
//  Created by mark on 15/4/26.
//  Copyright (c) 2015年 MKW. All rights reserved.
//

#ifndef Sunflower_ServerProxy_h
#define Sunflower_ServerProxy_h

#import "JSONServerProxy.h"
#import "HTMLServerProxy.h"

#pragma mark - 设置小区
// 所有已开通城市列表
#define k_API_ALL_OPENED_CITY           @"china/opencity"
// 通过城市 获取区域列表
#define k_API_ALL_CITY_AREA             @"china/area"
// 通过省、市、区、关键字 获取小区列表
#define k_API_COMMUNITY_QUERY           @"community/query"

#pragma mark - 首页
#define k_API_MAIN_COMMUNITYINFO_QUERY  @"community/detail/"
#define k_URL_ZHOUBIANYOU               @"http://www.qunar.com"

#pragma mark - 物业服务
// 通过小区ID 获取小区详情
#define k_API_COMMUNITY_QUERY_BY_ID     @"community/detail/"
// 修改小区信息
#define k_API_COMMUNITY_INFO_UPDATE     @"community/update"
// 通过小区ID 获取小区公告列表
#define k_API_C_NOTE_QUERY_BY_ID        @"notice/list/"
// 修改小区公告
#define k_API_C_NOTE_UPDATE             @"notice/update"
// 发布新公告
#define k_API_C_NOTE_ADD                @"notice/add"
// 删除小区公告
#define k_API_C_NOTE_DELETE             @"notice/delete/"
// 公告详情
#define k_API_C_NOTE_DETAIL             @"notice/detail/"
// 通过小区ID 获取管家列表
#define k_API_C_GUANJIA_QUERY_BY_ID     @"housekeeper/list/"
// 通过管家ID 给管家点赞
#define k_API_C_GUANJIA_UP_BY_ID        @"action/housekeeper/like/"
// 删除管家
#define k_API_C_GUANJIA_DELETE            @"housekeeper/delete/"
// 修改管家信息
#define k_API_C_GUANJIA_UPDATE            @"housekeeper/update"
// 添加新管家
#define k_API_C_GUANJIA_ADD               @"housekeeper/add"
// 停车费未缴
#define k_API_C_CHARGE_PARK_NOTPAY_QUERY    @"charge/parkfee/notpay"
// 停车费已缴
#define k_API_C_CHARGE_PARK_HASPAY_QUERY    @"charge/parkfee/haspay"
// 卫生费未缴
#define k_API_C_CHARGE_CLEAN_NOTPAY_QUERY   @"charge/rubbishfee/notpay"
// 卫生费已缴
#define k_API_C_CHARGE_CLEAN_HASPAY_QUERY   @"charge/rubbishfee/haspay"
// 取暖费未缴
#define k_API_C_CHARGE_WARM_NOTPAY_QUERY    @"charge/heatfee/notpay"
// 取暖费已缴
#define k_API_C_CHARGE_WARM_HASPAY_QUERY    @"charge/heatfee/haspay"
// 物管费未缴
#define k_API_C_CHARGE_PROPERTY_NOTPAY_QUERY    @"charge/managercharge/notpay"
// 物管费已缴
#define k_API_C_CHARGE_PROPERTY_HASPAY_QUERY    @"charge/managercharge/haspay"
// 生成缴费定单
#define k_API_C_CHARGE_ORDER_CREATE         @"chargeorder/order"
// 维修保养添加
#define k_API_C_FIX_ISSUE_ADD               @"feedback/add"
// 维修保养列表
#define k_API_C_FIX_ISSUE_QUERY             @"feedback/manage"
// 维修保养处理
#define k_API_C_FIX_ISSUE_DONE              @"feedback/finish"
// 维修保养其它推荐
#define k_API_C_FIX_SUGGEST_QUERY           @"repairservice/list"

#pragma mark - 社区生活
// 获取周边优惠列表
#define k_API_L_COUPON_LIST_QUERY       @"coupon/list"
// 通过优惠券ID 获取优惠详情
#define k_API_L_COUPON_DETAIL_QUERY     @"coupon/detail/"
// 通过优惠券ID 领取优惠券
#define k_API_L_COUPON_ADD              @"coupon/add"
// 优惠券评论列表
#define k_API_L_COUPON_COMMENT_QUERY    @"couponcomment/list"
// 优惠券评论管理列表
#define k_API_L_COUPON_COMMENT_MANAGE   @"couponcomment/manage"
// 用户优惠券评论列表
#define k_API_L_COUPON_COMMENT_MY       @"couponcomment/mylist"
// 优惠券评论添加
#define k_API_L_COUPON_COMMENT_ADD      @"couponcomment/add"
// 优惠券评论设置显示
#define k_API_L_COUPON_COMMENT_SHOW     @"couponcomment/show"
// 优惠券评论设置隐藏
#define k_API_L_COUPON_COMMENT_HIDE     @"couponcomment/hide"
// 优惠券评论删除
#define k_API_L_COUPON_COMMENT_DELETE   @"couponcomment/delete"
// 优惠券调查问卷列表
#define k_API_L_COUPON_JUDGE_QUERY      @"question/getdetail"
// 优惠券调查问卷添加
#define k_API_L_COUPON_JUDGE_ADD        @"question/add"
// 优惠券调查问卷结果
#define k_API_L_COUPON_JUDGE_RESULT     @"question/couponstatcount"
// 优惠券调查问卷提交
#define k_API_L_COUPON_JUDGE_SUBMIT     @"question/log/listadd"

// 获取生活服务列表
#define k_API_L_SERVICE_LIST_QUERY      @"lifeservice/list/"

// 房屋租售-添加房屋
#define k_API_L_HOUSE_ADD               @"housesale/add"
// 房屋租售-修改房屋
#define k_API_L_HOUSE_MODIFY            @"housesale/update"
// 房屋租售-小区租凭列表
#define k_API_L_HOUSE_LIST_QUERY_BY_ID  @"housesale/list/"
// 房屋租售-小区租赁分类列表
#define k_API_L_HOUSE_LIST_QUERY_BY_TYPE    @"housesale/listbytype/"
// 房屋租售-单条房屋信息
#define k_API_L_HOUSE_DETAIL            @"housesale/detail/"
// 社区黄页列表
#define k_API_L_INFO_LIST_QUERY         @"shopinfo/list"
// 微社区帖子及评论列表
#define k_API_L_WEI_LIST_QUERY          @"comment/list"
// 微社区帖子及评论添加
#define k_API_L_WEI_ADD                 @"comment/add"
// 微社区帖子及评论点赞
#define k_API_L_WEI_UP                  @"action/comment/like/"
// 获取地理位置信息
#define k_API_L_LOCATION_QUERY          @"http://api.map.baidu.com/geocoder/v2/?ak=SKRrGbx3IpXZeej9PGTVi0si&callback=renderReverse&location=%@,%@&output=json&pois=1&coordtype=gcj02ll"
// 微社区帖子不感兴趣
#define k_API_L_WEI_UNLIKE              @"comment/notinterest"
// 微社区帖子举报
#define k_API_L_WEI_REPORT              @"comment/police"
// 微社区帖子删除
#define k_API_L_WEI_DELETE              @"comment/delete"
// 微社区我的帖子列表
#define k_API_L_WEI_MY_QUERY            @"comment/mylist"



#pragma mark - 上传
#define k_API_UPLOAD_IMAGE              @"uploadimage.ashx"


#pragma mark - 个人中心-业主
// 获取手机验证码
#define k_API_P_CHECKCODE_QUERY             @"user/phonecode"
// 用户注册
#define k_API_P_USER_REGISTER               @"user/Reg"
// 普通用户 用户名密码登录
#define k_API_P_USER_LOGIN_NORMAL           @"user/login"
// 普通用户修改信息
#define k_API_P_USER_INFO_UPDATE            @"user/Update"
// 普通用户重置密码
#define k_API_P_USER_RESET_PASSWD           @"user/setpass"
// 获取我的可用优惠券列表
#define k_API_P_COUPON_MY_QUERY             @"coupon/my/"
// 获取我的过期优惠券列表
#define k_API_P_COUPON_MY_EXPIRED_QUERY     @"coupon/myexpired/"
// 获取我的已使用优惠券列表
#define k_API_P_COUPON_MY_USED_QUERY        @"coupon/myhasused/"
// 删除我的优惠券
#define k_API_P_COUPON_MY_DELETE            @"coupon/delete"
// 批量删除我的优惠券
#define k_API_P_COUPON_MY_DELETE_ARRAY      @"coupon/deletebatch"
// 领取优惠券
#define k_API_P_COUPON_MY_ADD               @"coupon/add"
// 房屋租售-我的租凭列表
#define k_API_P_HOUSE_MY_LIST_QUERY     @"housesale/mylist/"
// 房屋租售-我的单条房屋删除
#define k_API_P_HOUSE_MY_DELETE         @"housesale/delete/"
// 房屋租售-我的房屋批量删除
#define k_API_P_HOUSE_MY_DELETE_ARRAY   @"housesale/deletebatch"
// 微社区我的帖子及评论列表
#define k_API_P_WEI_MY_LIST_QUERY       @"comment/mylist"
// 获取业主认证预留手机号码
#define k_API_P_AUDIT_TELNUM_QUERY      @"user/getauditphonenum"
// 业主认证
#define k_API_P_AUDIT_AUDIT             @"user/audit"
// 用户积分
#define k_API_P_USER_POINT_ADD          @"points/add"
// 我的维修保养列表
#define k_API_P_FIX_QUERY               @"feedback/mylist"
// 删除维修保养
#define k_API_P_FIX_DELETE              @"feedback/delete"
// 我的缴费列表
#define k_API_P_CHARGE_QUERY            @"charge/mypaylist/"

// 第三方登录
#define k_API_P_USER_LOGIN_SOCIAL       @"user/social/login"

// 积分规则
#define k_API_P_USER_POINT_RULE_QUERY   @"pointsinfo/list"

// 用户协议
#define k_API_USER_ANNOUNCE             @"user_announce.html"
// 商记协议
#define k_API_BUSINESS_ANNOUNCE         @"seller_announce.html"
// 物业协议
#define k_API_PROPERTY_ANNOUNCE         @"service_announce.html"


#pragma mark - 个人中心-商家
// 商家登录
#define k_API_P_USER_LOGIN_BUSINESS     @"adminuser/property/login"
// 商户注册
#define k_API_P_USER_REGIST_BUSINESS    @"adminuser/property/reg"
// 商户重置密码
#define k_API_P_USER_REST_PASSWD_BUSINESS   @"adminuser/setpass"
// 商家信息
#define k_API_P_SHOP_INFO               @"seller/detail"
// 修改商家信息
#define k_API_P_SHOP_INFO_UPDATE        @"seller/update"
// 添加分店
#define k_API_P_SHOP_ADD_STORE          @"seller/addshop"
// 修改分店信息
#define k_API_P_SHOP_UPDATE_STORE       @"seller/updateshop"
// 删除分店
#define k_API_P_SHOP_DELETE_STORE       @"seller/deleteshop"

// 商家优惠列表
#define k_API_P_SHOP_COUPON_QUERY       @"sellercoupon/list/"
// 添加优惠
#define k_API_P_SHOP_COUPON_ADD         @"sellercoupon/add"
// 修改优惠
#define k_API_P_SHOP_COUPON_UPDATE      @"sellercoupon/update"
// 删除优惠
#define k_API_P_SHOP_COUPON_DELETE      @"sellercoupon/delete"

// 优惠券用户列表
#define k_API_P_SHOP_COUPON_USER_QUERY  @"sellercoupon/joinlist"
// 优惠券设为使用
#define k_API_P_SHOP_COUPON_USER_USE    @"sellercoupon/sethasuse"


#pragma mark - 个人中心-物业
// 物业登录
#define k_API_P_USER_LOGIN_PROPERTY     @"adminuser/login"
// 物业申请
#define k_API_P_USER_APPLY_PROPERTY     @"apply/add"

#define k_API_P_USER_ADMINE_INFO_UPDATE @"adminuser/Update"
#endif
