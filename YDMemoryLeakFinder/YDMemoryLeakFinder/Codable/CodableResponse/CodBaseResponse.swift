//
//  APIBaseResponse.swift
//  Alamofire
//
//  Created by sujp on 2022/11/15.
//

import Foundation

public struct CodBaseResponse<T: Codable>: CodableConvertProtocol {
    
    public let Result: T?
    public let ResultNo: Int?
    public let Message: String?
    public let Total: Int?
    
    // 首页广告接口返回的code和message
    public var RMessage: String?
    public var RCode: Int?
//    public init(from decoder: Decoder) throws {
//        if let container = try? decoder.container(keyedBy: CodingKeys.self){
//            container.decode(<#T##type: Default<DefaultValue>.Type##Default<DefaultValue>.Type#>, forKey: <#T##CodBaseResponse<Decodable & Encodable>.CodingKeys#>)
//        }
//    }
}

