//
//  CodStoreListParams.swift
//  ZFBaseModule
//
//  Created by sujp on 2022/12/13.
//

import Foundation

public enum StoreListType{
    case Map              //地图
    case NearBy           //列表附近
    case Default          //默认无类型
    case SearchWithRegion //区域板块内关键字搜索
}

public struct CodStoreListParams: CodableConvertProtocol {
    
    public init() {}
    
    public var PageIndex: Int?
    public var PageCount: Int?
    /// 门店ID
    public var StoreID:Int?
    /// 门店名称
    public var StoreName:String?
    /// 门店电话
    public var StoreTel:String?
    /// 板块ID
    public var GscopeID:Int?
    /// 区域ID
    public var RegionID:Int?
    /// 坐标-经度
    public var Lng:Double?
    /// 坐标-维度
    public var Lat:Double?
    /// 半径
    public var Round:Int?
    /// 坐标-最小经度
    public var MinLng:Double?
    /// 坐标-最小维度
    public var MinLat:Double?
    /// 坐标-最大经度
    public var MaxLng:Double?
    /// 坐标-最大维度
    public var MaxLat:Double?
    /// 排序方式
    public var OrderByCriteria:String?
    /// 经纪人是否放盘
    public var MustHasPost:Bool?
    /// 400大渠道
    public var Sem:String?
    /// 400小渠道
    public var Hmpl:String?
    /// 是否展示距离
    public var isShowDistance:Bool?
    /// 是否被选中
    public var isSelect:Bool?
    
}

