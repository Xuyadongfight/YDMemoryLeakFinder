//
//  TestVC.swift
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/1/11.
//

import UIKit

@objcMembers
class TestVC: UIViewController,UIScrollViewDelegate{
    static var tempY : CGFloat = 10
    private var strongVCPrivate : TestVC?
    var strongVC : TestVC?
    var closureOfTest = {}
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        self.strongVC = self;
        self.closureOfTest = {
            print(self);
        }
        return;
    }
}


