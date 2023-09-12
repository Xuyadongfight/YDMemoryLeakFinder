//
//  CodStoreListResponse.swift
//  ZFBaseModule
//
//  Created by sujp on 2022/12/13.
//

import Foundation

// 自定义对象 array 默认值
public typealias DefaultStaffArray = DefaultArray<CodStoreListStaff>
extension CodStoreListStaff: DefaultArrayValue {
    public static var defaultArrayValue = [CodStoreListStaff]()
    
}

public typealias DefaultStoreEstateArray = DefaultArray<CodStoreToEstates>
extension CodStoreToEstates: DefaultArrayValue {
    public static var defaultArrayValue = [CodStoreToEstates]()
    
}

// 门店列表
public typealias CodStoreListResponse = CodBaseResponse<[CodStoreListResult]>

public struct CodStoreListResult: CodableConvertProtocol {
    public var Distance: Double?
    public var GScopeId: Int?
    public var HasPostStaffCount: Int?
    public var Lat: Double?
    public var Lng: Double?
    public var PaNo: String?
    public var RegionId: Int?
    public var StaffCount: Int?
    public var Store400Tel: String?
    public var StoreAddr: String?
    public var StoreHonor: String?
    public var StoreId: Int?
    public var StoreName: String?
    public var StoreTel: String?
    @DefaultStoreEstateArray public var StoreToEstates: [CodStoreToEstates]
    @DefaultStaffArray public var StoreToStaffs: [CodStoreListStaff]
    public var StreetViewUrl: String?
    /// 是否展示距离
    public var isShowDistance:Bool?
    /// 是否被选中
    public var isSelect:Bool?
}

public struct CodStoreListStaff: CodableConvertProtocol {
    
    public var AttentionCount: Int?
    public var BusinessLicenseName: String?
    public var ChatAnsweredRate: Float?
    public var CnName: String?
    public var CollectId: Int?
    public var ConsultCount: Int?
    public var CreateTime: Int?
    public var DPostNum: Int?
    public var EmployDate: Int?
    public var EmployDateStr: String?
    public var EvaluationCount: Int?
    public var FullImagePath: String?
    public var FullImagePathBig: String?
    public var FullImagePathJW: String?
    public var FullImagePathStore: String?
    public var Gender: String?
    public var GoodEvaluationCount: Int?
    public var GoodRate: Int?
    public var HitCount: Int?
    @DefaultBool public var IsDisableVR: Bool
    @DefaultBool public var IsStarStaff: Bool
    public var Label: String?
    public var Mobile: String?
    public var MobileImport: String?
    public var PositionID: Int?
    public var RPostNum: Int?
    public var ServiceYear: Int?
    public var SPostNum: Int?
    public var StaffID: String?
    public var StaffNo: String?
    public var StaffSpeciality: String?
    public var Status: String?
    public var StoreID: Int?
    public var StoreName: String?
    public var TakeSeeCount: Int?
    public var TakeToSeeCount: Int?
    public var Title: String?
    public var UpdateTime: Int?
    public var WorkYear: Int?
}


public class CodStoreToEstates: CodableConvertProtocol{
    /// 门店ID
    public var StoreID:Int?
    /// 楼盘Code
    public var EstateCode:String?
    /// 楼盘名称
    public var EstateName:String?
    /// 排序
    public var OrderBy:Int?
}

