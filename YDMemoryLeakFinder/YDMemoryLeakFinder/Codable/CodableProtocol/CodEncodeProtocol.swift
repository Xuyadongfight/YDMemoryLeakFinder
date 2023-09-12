//
//  CodEncoderProtocol.swift
//  ZFBaseModule
//
//  Created by sujp on 2022/11/29.
//

import Foundation

// MARK: - JSONEncoder
public typealias CodableConvertProtocol = Codable & CodBaseJSONConvert

public protocol CodBaseJSONConvert {
    
    func toJSONString() -> String?
    func toJSON() -> [String: Any]?
    static func deserialization(from dict: [String: Any]?) -> Self?
}

extension CodBaseJSONConvert where Self: Codable {
    
    /// model to string
    public func toJSONString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch  {
            return nil
        }
    }
    
    /// model to dict
    public func toJSON() -> [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(
                with: jsonData,
                options: .mutableContainers
            ) as? [String: Any]
            return json
        } catch  {
            return nil
        }
    }
    
    /// dict to model
    public static func deserialization(from dict: [String: Any]?) -> Self? {
        
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: dict ?? [:],
            options: .prettyPrinted) else {
                return nil
            }
        
        do {
            let model = try JSONDecoder().decode(Self.self, from: jsonData)
            return model
        } catch {
            return nil
        }
        
    }
    
    /// string to model
    public static func deserialization(from string: String?) -> Self? {
        
        guard let jsonData = string?.data(using: .utf8) else {
            return nil
        }
        
        do {
            let model = try JSONDecoder().decode(Self.self, from: jsonData)
            return model
        } catch {

            return nil
        }
    }
    
}

