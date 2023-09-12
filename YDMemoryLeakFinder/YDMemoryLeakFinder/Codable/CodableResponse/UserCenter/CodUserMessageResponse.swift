//
//  CodUserPointsResponse.swift
//  ZFBaseModule
//
//  Created by 月月 on 2022/12/14.
//

import Foundation

public typealias CodUserInfoResponse = CodBaseResponse<CodUserInfoResult>
// MARK: - 新房订阅接口返回的用户实体
public typealias CodUserInfoResultResponse = CodBaseResponse<CodUserInfo>

public struct CodUserInfo: CodableConvertProtocol {
    
    public let UserInfo: CodUserInfoResult?

}
// MARK: - 用户实体
public struct CodUserInfoResult: CodableConvertProtocol {
    /// 报名成功后编号
    public var BookingId : Int?
    /// 用户ID
    public var UserId:String?
    /// 用户昵称
    public var NickName:String?
    /// 用户密码
    public var PassWord:String?
    /// 用户Email
    public var Email:String?
    /// 用户电话
    public var Phone:String?
    /// 用户上次登录时间
    public var LastLoginDateTime:String?
    ///
    public var UpdateTime:String?
    ///
    public var CreateTime:String?
    ///
    public var UpdateTime2:TimeInterval?
    ///
    public var CreateTime2:TimeInterval?
    /// 头像地址
    public var UserPhotoUrl:String?
    /// Token
    public var UserToken:String?
    /// 用户
    public var QQAccount:String?
    /// 用户
    public var WeixinAccount:String?
    
    /// 是否设置过密码
    @DefaultBool public var IsSetNewPwd: Bool
    /// 用户
    @DefaultBool public var Status: Bool
    /// 是否推送房源
    @DefaultBool public var IsPushPost:Bool
    /// 是否推送小区
    @DefaultBool public var IsPushEstate:Bool
    /// 是否推送消息
    @DefaultBool public var IsPushChat:Bool
    /// 是否推送系统消息
    @DefaultBool public var IsPushSystemMsg:Bool
    /// 是否是新用户
    @DefaultBool public var IsNewUser:Bool
    ///经纪人登录带有工号
    public var StaffNo : String?
}
