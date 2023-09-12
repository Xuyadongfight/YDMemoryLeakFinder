//
//  CodCityInfoResponse.swift
//  ZFBaseModule
//
//  Created by 月月 on 2022/12/16.
//

import Foundation

public typealias CodCityInfoResponse = CodBaseResponse<[CodCityInfoResult]>


public struct CodCityInfoResult: CodableConvertProtocol {
    public var CityCnName:String?
    public var CityCode:String?
    public var CityShort:String?
    public var CityFull:String?
    public var CityDomain:String?
    public var CityDomainWap:String?
    public var City400Phone:String?
    public var IsShouErShouFang:String?
    public var IsShouXinFang:String?
    public var IsShowTalk:String?
    public var IsShowXieZiLou:String?
    public var IsShowNews:String?
    public var IsShowPostContrast:String?
    public var IsShowSchool:String?
    public var EvaluationText:String?
}

