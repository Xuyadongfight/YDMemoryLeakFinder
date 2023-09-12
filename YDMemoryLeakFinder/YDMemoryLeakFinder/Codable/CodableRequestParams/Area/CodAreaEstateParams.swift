//
//  CodAreaEstateParams.swift
//  ZFBaseModule
//
//  Created by sujp on 2022/11/29.
//

import Foundation


public struct CodAreaEstateParams: CodableConvertProtocol {
    
    public init() {}
    
    // 经度
    public var Lng: Double?
    // 纬度
    public var Lat: Double?
    // 经度
    public var lng: Double?
    // 纬度
    public var lat: Double?
    // 半径范围
    public var Round: Float?
    // 坐标-最小经度
    public var MinLng: Double?
    // 坐标-最小维度
    public var MinLat: Double?
    // 坐标-最大经度
    public var MaxLng: Double?
    // 坐标-最大维度
    public var MaxLat: Double?
    // 区域ID
    public var RegionId: Int?
    // 板块ID
    public var GScopeId: Int?
    public var GScopeIds: [Int]?
    // 地铁线Id 非必传
    public var RailLineId: Int?
    // 地铁站Id
    public var RailWayId: Int?
    public var RailWayIds: [Int]?
    // 小区名称
    public var EstateName: String?
    // 支持 拼音、全拼，地址模糊搜索
    public var HybridKey: String?
    // 最小售均价
    public var MinSaleAvgPrice: Double?
    // 最大售均价
    public var MaxSaleAvgPrice: Double?
    // 楼盘最低售价
    public var MinSalePrice: Double?
    // 楼盘最大售价
    public var MaxSalePrice: Double?
    // 小区排序条件
    public var OrderByCriteria: String?
    // 建造年代 字符串形式:"2010-1-1^2010-1-1,2006-1-1^2010-12-31,1996-1-1^2000-12-31"
    public var OpdateRanges: String?
    // 小区特色（多个传过个id以_割开）
    public var Feature: String?
    // 物业类型 字符串形式:"住宅,酒店式公寓,别墅,办公楼"
    public var PropertyTypes: String?
    // 楼层 字符串形式:"低层,中层,高层"
    public var Floors: String?
    // 朝向 字符串形式:"南,东西,南北"
    public var Directions: String?
    // 房型 字符串形式:"1^1,3^3,5^5,6^14"
    public var RoomCountRanges: String?
    // 图片宽度(必填)
    public var ImageWidth: CGFloat?
    // 图片高度（必填）
    public var ImageHeight: CGFloat?
    // 返回结果中需要排除小区的code集合
    public var RemovedEstateCodes: [String]?
    /// 最小面积
    public var MinGArea: String?
    /// 最大面积
    public var MaxGArea: String?
    /// 装修
    public var Fitments: String?
    /// postType
    public var PostType: String?
    
    public var MaxRentPrice: String?
    
    public var MinRentPrice: String?
    
    /// 学校id
    public var SchoolId: Int?
    
}

