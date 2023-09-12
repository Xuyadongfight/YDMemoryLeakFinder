//
//  CodCityResponse.swift
//  ZFBaseModule
//
//  Created by sujp on 2022/12/12.
//

import Foundation

public enum CityTypeCod:String,CodableConvertProtocol {
    case JTMainPage         //集团版本首页
    case SZCityMainPage     //深圳版本首页
    case SZSubCityMainPage  //中山珠海首页
    case SubCityMainPage    //天津 长春新房大首页
}

public typealias CodCityResponse = CodBaseResponse<[CodCityResult]>

public struct CodCityResult: CodableConvertProtocol {
    
    public var Abbr: String?
    public var ActivityUrl: String?
    public var AdLink: String?
    public var AgentPhoto: String?
    public var APIUrl: String?
    public var APPGSPUrl: String?
    public var APPXZLUrl: String?
    public var BizcommonUrl: String?
    public var CityEn: String?
    public var CityName: String?
    public var Code: String?
    public var FindPropertyBlog: String?
    public var FindPropertyView: String?
    public var GSPUrl: String?
    public var iAplusApiUrl: String?
    public var IntegralApiUrl: String?
    @DefaultBool public var IsHot: Bool
    public var JavaBizCommonUrl: String?
    public var JavaUserCenterUrl: String?
    public var MainPage: CityTypeCod?
    public var NewPropUrl: String?
    public var NewsAPIUrl: String?
    public var PostImage: String?
    public var ScrmQyApiUrl: String?
    public var Spell: String?
    public var SZApiUrl: String?
    public var Talk: String?
    public var WebSite: String?
    public var XZLUrl: String?
    /// 判断城市实体是否是中山或者珠海 用来处理双首页的问题
    public var isCityZSOrZH : Bool{
        if let cityType = MainPage,cityType == .SZSubCityMainPage{
            return true
        }
        return false
    }
    /// 判断城市实体是否是深圳
    public var isCitySZ: Bool {
        if let cityType = MainPage,cityType == .SZCityMainPage{
            return true
        }
        return false
    }
    /// 判断城市实体是否是新房大首页
    public var isCityBigPage: Bool {
        if let cityType = MainPage,cityType == .SubCityMainPage{
            return true
        }
        return false
    }
    
    // MARK: -  特殊城市跳h5链接
    public var ExternalAppLink : String?
    
    // MARK: - 添加自定义参数，城市中心点坐标，从personalize里面返回
    public var cityCenterLat: String?
    public var cityCenterLng: String?
    /// 官方消息详情对应的url地址
    public var domain: String?
    
}

