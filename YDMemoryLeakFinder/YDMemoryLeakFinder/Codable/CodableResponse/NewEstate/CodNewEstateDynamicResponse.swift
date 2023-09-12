//
//  CodNewEstateDynamicResponse.swift
//  Alamofire
//
//  Created by sujp on 2022/11/18.
//

import Foundation

// 新房动态

public typealias CodNewEstateDynamicResponse = CodBaseResponse<[CodNewEstateDynamicResult]>

public struct CodNewEstateDynamicResult: CodableConvertProtocol {

    @DefaultInt public var AgreeCount: Int
    @DefaultInt public var InfoId: Int
    @DefaultInt public var InfoType: Int
    @DefaultInt public var ShowVisitCount: Int
    @DefaultInt public var VisitCount: Int
    
    public var AuthorName: String?
    public var CoverUrl: String?
    public var CreateTime: String?
    public var Description: String?
    public var DetailUrl: String?
    public var EstId: String?
    public var InfoContent: String?
    public var InfoTag: String?
    public var InfoTitle: String?
    public var UpdateTime: String?
    public var customParam1: String?
}

