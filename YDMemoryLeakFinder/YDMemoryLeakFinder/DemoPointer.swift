//
//  DemoPointer.swift
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/11/23.
//

import Foundation

protocol MyProtocol{
    var myVar1 : String { get set}
    var myVar2 : String { get }
}


@frozen public struct EmptyStruct<Test>{
    typealias Test = UInt8
     public var test : Test?
}

struct SampleStruct{
    let number:UInt32
    let flag : Bool
}

class People{
    var name: String
    init(_ name:String) {
        self.name = name
    }
    deinit {
        print(self.name,"dealloc")
    }
}
class Student : People{
    
}
class Teacher:People{
    var myStudent : Student?
    /*
     开闭原则 单一职责原则 依赖倒置原则  接口隔离原则 迪米特法则 里式替换原则
     创建型5 单例模式 工厂模式 抽象工厂模式 建造者模式 原型模式
     结构型7 桥接模式 装饰器模式 外观模式 组合模式 适配器模式 代理模式 享元模式
     行为型11 策略模式 模板模式 观察者模式 迭代器模式 责任链模式 命令模式 备忘录模式 状态模式 访问者模式 中介者模式 解释器模式
     */
}

class DemoPointer{
    /*
     指针
     UnsafePointer;
     UnsafeRawPointer;
     UnsafeBufferPointer;
     UnsafeRawBufferPointer;
     
     */
    func test() {
        // 创建指针
        let count = 2
        let stride = MemoryLayout<Int>.stride
        let alignment = MemoryLayout<Int>.alignment
        let byteCount = stride * count
        
        var ptrIntMut = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        ptrIntMut.pointee = 16
        ptrIntMut[0] = 32
        print(ptrIntMut)
        
        var number = 5
        let numberPtr = UnsafePointer(&number)
        
        
        
//        var empty = EmptyStruct<Int>()
//        print(empty)
        func printInt(atAddress p :UnsafePointer<Any>){
            print(p.pointee)
        }
        

        do {
            let ptrInt : UnsafePointer<Int>?
            let ptrIntMut : UnsafeMutablePointer<Int>?
            let ptrRaw : UnsafeRawPointer?
            let ptrRawMut : UnsafeMutableRawPointer?
            
//            print(ptrInt?.pointee)
            let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
            pointer.storeBytes(of: 16, as: Int.self)
            pointer.storeBytes(of: 32, toByteOffset: stride, as: Int.self)
            let a = pointer.load(as: Int.self) //a = 16
            let b = pointer.load(fromByteOffset: stride, as: Int.self) // b = 32
            print(a,b)
            pointer.deallocate()
        
            
        }
        do {
            let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
            pointer.initialize(repeating: 0, count: count)
            pointer.pointee = 16
            pointer.advanced(by: 1).pointee = 32
            
            let a = pointer.pointee // a = 16
            let b = pointer.advanced(by: 1).pointee // b = 32
            print(a,b)
            pointer.deinitialize(count: count)
            pointer.deallocate()
        }
        var studenta = Student("学生a")
        let studentb = Student("学生b")
        var teachera = Teacher("老师a")
        var teacherb = Teacher("老师b")
        teachera.myStudent = studenta
//        teacherb.myStudent = studentb
        
//        do{
//            let ptrTa = withUnsafeMutablePointer(to: &teachera) { ptr in
//                return ptr
//            }
//            let ptrSa = withUnsafeMutablePointer(to: &studenta) { ptr in
//                return ptr
//            }
//            let temp = UnsafeMutableRawPointer(ptrTa).nextPointer()
//
//            let UIntTa = UnsafeMutableRawPointer(ptrTa).load(fromByteOffset: 0, as: UInt.self)
//            let UIntSa = UnsafeMutableRawPointer(ptrSa).load(fromByteOffset: 0, as: UInt.self)
//            print(teachera.myStudent?.name)
//
//            if  let rawPointer = UnsafeMutableRawPointer(bitPattern: UIntTa){
////                rawPointer.storeBytes(of: studenta, toByteOffset: 32, as: Student.self)
////                rawPointer.storeBytes(of: UIntSa, toByteOffset: 32, as: UInt.self)
//                let offSet = rawPointer.advanced(by: 32)
//                offSet.bindMemory(to: Student.self, capacity: 1).deinitialize(count: 1)
//                offSet.initializeMemory(as: Student.self, repeating: studentb, count: 1)
//            }
//            print(teachera.myStudent?.name)
//        }
    }
}


//extension UnsafeMutableRawPointer{
//
//    public func nextPointer(){
//        let next : UnsafeMutableRawPointer? = self
//        if var upNext = next{
//            while upNext.isPointer() {
//                print(upNext)
//                if let temp = UnsafeMutableRawPointer(bitPattern: upNext.load(fromByteOffset: 0, as: UInt.self)){
//                    upNext = temp
//                }else{
//                    break
//                }
//            }
//            print(upNext)
//        }
//    }
//
//    public func isPointer()->Bool{
//        let tempPtr = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)
//        defer{
//            tempPtr.deallocate()
//        }
//        return true
//    }
//}
