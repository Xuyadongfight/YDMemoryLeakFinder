//
//  LookEstateRecordResponse.swift
//  ZFBaseModule
//
//  Created by 月月 on 2022/12/16.
//

import Foundation

public typealias CodLookEstateRecordResponse = CodBaseResponse<[CodLookEstateRecordListResult]>

// MARK: - 用户实体
public struct CodLookEstateRecordListResult: CodableConvertProtocol {
    // 带看id
    public var LookPostId: String?
    // 日期
    public var CreateTime: TimeInterval?
    // 房源 id
    public var EstateID: String?
    // 城市编码
    public var CityCode: String?
    // 名称
    public var EstateName: String?
    // 室数
    public var RoomCount: Int?
    // 厅数
    public var HallCount: Int?
    // 面积
    public var Area: Float?
    // 售价
    public var SalePrice: Float?
    // 租金
    public var RentPrice: Float?
    //
    public var PropId: String?
    // 经纪人名称
    public var StaffName: String?
    // 经纪人编号
    public var StaffNo: String?
    // 客户手机号码
    public var CustomerMobile: String?
    // 房源类型
    public var PostType: String?
    
    public var EvaluateStatus: String?
}
