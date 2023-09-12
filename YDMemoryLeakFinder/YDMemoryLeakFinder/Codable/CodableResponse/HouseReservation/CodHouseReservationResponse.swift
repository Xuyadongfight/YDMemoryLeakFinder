//
//  CodHouseReservationResponse.swift
//  ZFBaseModule
//
//  Created by 月月 on 2022/12/16.
//

import Foundation

// MARK: - 约看实体
public typealias CodHouseReservationResponse = CodBaseResponse<[CodHouseReservationResult]>


public struct CodHouseReservationResult: CodableConvertProtocol {
    //
    public var EstateCode: String?
    //
    public var UserId: String?
    //
    public var EstateName: String?
    //
    public var StaffNo: String?
    //
    public var UpdateTime: TimeInterval?
    //
    public var CustomerSex: String?
    //
    public var Source: String?
    //
    public var IsReserve: Bool?
    //
    public var PostID: String?
    //
    public var AppName: String?
    //
    public var CustomerName: String?
    //
    public var StaffName: String?
    //
    public var CityCode: String?
    //
    public var ReserveID: Int?
    //
    public var CreateTime: TimeInterval?
    //
    public var CustomerMobile: String?
}
