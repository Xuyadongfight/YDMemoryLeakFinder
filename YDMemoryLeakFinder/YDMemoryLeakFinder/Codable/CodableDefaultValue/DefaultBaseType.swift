//
//  DefaultBaseType.swift
//  HseDomainProject
//
//  Created by sujp on 2022/11/24.
//

import Foundation
import UIKit

// MARK: - Bool
public typealias DefaultBool = Default<Bool>

extension Bool: DefaultValue {
    public static var defaultValue = false
}

// MARK: - Double
public typealias DefaultDouble = Default<Double>

extension Double: DefaultValue {
    public static var defaultValue = 0.0
}

// MARK: - Float
public typealias DefaultFloat = Default<Float>

extension Float: DefaultValue {
    public static var defaultValue = 0.0
}

// MARK: - Int
public typealias DefaultInt = Default<Int>

extension Int: DefaultValue {
    public static var defaultValue = 0
}

// MARK: - String
public typealias DefaultString = Default<String>

extension String: DefaultValue {
    public static var defaultValue = ""
}

// MARK: - UInt
public typealias DefaultUInt = Default<UInt>

extension UInt: DefaultValue {
    public static var defaultValue = 0
}


// MARK: - String Array
public typealias DefaultStringArray = DefaultArray<String>
extension String: DefaultArrayValue {
    public static var defaultArrayValue = [String]()
}

// MARK: - Int Array
public typealias DefaultIntArray = DefaultArray<Int>
extension Int: DefaultArrayValue {
    public static var defaultArrayValue = [Int]()
}
