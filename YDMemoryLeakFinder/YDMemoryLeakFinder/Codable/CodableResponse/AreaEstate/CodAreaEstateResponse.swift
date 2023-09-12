//
//  CodAreaEstateResponse.swift
//  ZFBaseModule
//
//  Created by sujp on 2022/11/28.
//

import Foundation

public typealias CodAreaEstateResponse = CodBaseResponse<[CodAreaEstateListResult]>

public struct CodAreaEstateListResult: CodableConvertProtocol {
    public var Address: String?
    public var AirlookId: String?
    
    @DefaultDouble public  var DealAvgPrice: Double
    @DefaultInt public var DealNumber: Int
    
    public var Developers: String?
    
    @DefaultDouble public var Distance: Double
    
    public var EstateAlias: String?
    public var EstateCode: String?
    public var EstateId: String?
    public var EstateName: String?
    
    @DefaultInt public var EstateSimilarCount: Int
    
    public var EstateType: String?
    public var FirstPY: String?
    public var FullImagePath: String?
    public var FullPY: String?
    public var GscopeName: String?
    
    @DefaultInt var GscopeId: Int
    @DefaultInt var HRentNumber: Int
    @DefaultInt var HSaleNumber: Int
    
    public var ImageDestExt: String?
    public var ImageFullPath: String?
    public var ImagePath: String?
    
    @DefaultBool public var IsDealHot: Bool
    @DefaultBool public var IsRailWay: Bool
    @DefaultBool public var IsSchool: Bool
    @DefaultBool public var IsVideo: Bool
    @DefaultDouble public var GuidingPrice: Double
    @DefaultDouble public var Lat: Double
    @DefaultDouble public var Lng: Double
    @DefaultDouble public var MaxRentPrice: Double
    @DefaultDouble public var MaxSalePrice: Double
    @DefaultDouble public var MinRentPrice: Double
    @DefaultDouble public var MinSalePrice: Double
    @DefaultDouble public var OpDate: TimeInterval
    
    public var PaNo: String?
    public var PanoramaImageUrl: String?
    public var PanoramaUrl: String?
    public var PanoramicToolUrl: String?
    public var PropertyType: String?
    public var RailwayInfos: [CodAreaEstateRailwayInfos]?
    
    @DefaultInt public var RegionId: Int
    public var RegionName: String?
    
    @DefaultDouble public var RentAvgPrice: Double
    @DefaultInt public var RentNumber: Int
    @DefaultDouble public var SaleAvgPrice: Double
    @DefaultDouble public var SaleAvgPriceRise: Double
    @DefaultInt public var SaleNumber: Int
    @DefaultDouble public var Score: Double
    @DefaultBool public var ShowInWeb: Bool
    
    // 商圈
    public var EstateVideo: CodAreaEstateVideo?
    
    /// 实际售价
    public var SalePriceInfo: CodCommonSalePriceInfo?
    /// 指导售价
    public var SalePriceGov: CodCommonSalePriceInfo?
    
    /// 指导均价
    public var SaleAvgPriceGov: CodCommonSalePriceInfo?
    /// 实际均价
    public var SaleAvgPriceInfo: CodCommonSalePriceInfo?
    
    // 是否存在全景视频
    public var isAllView: Bool? {
        // 如果有全景添加全景
        if let panoramicToolUrl = PanoramicToolUrl, !panoramicToolUrl.isEmpty {
            return true
        }
        return false
    }
    
    /// 小区价格
    public func getAreaPriceInfo() -> CodCommonSalePriceInfo? {
        let unitPrice = SaleAvgPrice
        let guidingPrice = GuidingPrice
        
        if guidingPrice > 0 && guidingPrice <= unitPrice {
            // 显示指导价
            if let govPrice = SaleAvgPriceGov, govPrice.Show {
                return govPrice
            }
        } else if let salePrice = SaleAvgPriceInfo, (unitPrice > 0), salePrice.Show {
            // 实际价格
            return salePrice
        }
        
        return nil
    }
    
}

public struct CodAreaEstateRailwayInfos: CodableConvertProtocol {
    
    @DefaultDouble public var Distance: Double
    @DefaultInt public var RailLineId: Int
    public var RailLineName: String?
    @DefaultInt public var RailWayID: Int
    public var RailWayName: String?
    @DefaultInt public var WalkTime: Int
}

public class CodAreaEstateVideo: CodableConvertProtocol {
    
    // 商圈名称
    public var GscopeName: String?
    // id
    public var RowId: Int?
    // 房源id
    public var EstateId: String?
    // 视频路径
    public var VideoPath: String?
    // 视频图片
    public var VideoImage: String?
    // 描述文字
    public var Remark: String?
}

/// 价格公共实体
public class CodCommonSalePriceInfo: CodableConvertProtocol{
    /// 价格单位
    public var PriceUnit: String?
    /// 价格字符串
    public var Price: String?
    /// 价格前缀
    public var PriceText: String?
    /// 当前价格是否显示
    @DefaultBool public var Show: Bool
    
    /// 显示价格，带文案
    public var showTextStr: String? {
        var salePriceStr = ""
        if let priceText = PriceText, !priceText.isEmpty {
            salePriceStr = priceText + "："
        }
        if let price = Price {
            salePriceStr += price
        }
        
        if let priceUnit = PriceUnit {
            salePriceStr += priceUnit
        }
        return salePriceStr
    }
    
    /// 显示价格，不带文案
    public var showPriceOnly: String? {
        var salePriceStr = ""
        if let price = Price {
            salePriceStr += price
        }
        
        if let priceUnit = PriceUnit {
            salePriceStr += priceUnit
        }
        
        return salePriceStr
    }
}
