//
//  DefaultBase.swift
//  HseDomainProject
//
//  Created by sujp on 2022/11/24.
//

import Foundation
import UIKit

public protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

@propertyWrapper
public struct Default<T: DefaultValue> {
    
    public var wrappedValue: T.Value
    
    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
    
}

extension Default: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

//extension KeyedDecodingContainer {
//    
//    public func decode<T>(
//        _ type: Default<T>.Type,
//        forKey key: Key
//    ) throws -> Default<T> where T: DefaultValue {
//
//        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
//    }
//}


// MARK: - 集合类型Default

public protocol DefaultArrayValue {
    associatedtype Value: Codable
    static var defaultArrayValue: [Value] { get }
}

@propertyWrapper
public struct DefaultArray<T: DefaultArrayValue> {
    public var wrappedValue: [T.Value]
    
    public init(wrappedValue: [T.Value]) {
        self.wrappedValue = wrappedValue
    }
    
}

extension DefaultArray: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var results = [T.Value]()
        while !container.isAtEnd {
            let value = try container.decode(T.Value.self)
            results.append(value)
        }
        wrappedValue = results
    }
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

//extension KeyedDecodingContainer {
//
//    public func decode<T>(
//        _ type: DefaultArray<T>.Type,
//        forKey key: Key
//    ) throws -> DefaultArray<T> where T: DefaultArrayValue {
//
//        try decodeIfPresent(type, forKey: key) ?? DefaultArray(wrappedValue: T.defaultArrayValue)
//    }
//}

