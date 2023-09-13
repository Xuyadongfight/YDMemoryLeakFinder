//
//  TestVC.swift
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/1/11.
//

import UIKit


@objcMembers
class TestVC: UIViewController,UIScrollViewDelegate,CAAnimationDelegate{
    private var strongVCPrivate : TestVC?
    fileprivate var strongVCFileprivate : TestVC?
    var tempY : CGFloat = 10
    var strongVC : TestVC?
    var closureOfTest = {}
    var timer : Timer?
    var displayLink : CADisplayLink?
    
    fileprivate lazy var vBtnCycleVC : UIButton = {
        let temp = UIButton()
        temp.frame = CGRect.init(x: 100, y: 100, width: 200, height: 40)
        temp.setTitle("cycleVC", for: .normal)
        temp.setTitleColor(.red, for: .normal)
        temp.addTarget(self, action: #selector(cycleVC), for: .touchUpInside)
        return temp
    }()
    fileprivate lazy var vBtnCycleClosure : UIButton = {
        let temp = UIButton()
        temp.frame = CGRect.init(x: 100, y: 200, width: 200, height: 40)
        temp.setTitle("cycleClosure", for: .normal)
        temp.setTitleColor(.red, for: .normal)
        temp.addTarget(self, action: #selector(cycleClosure), for: .touchUpInside)
        return temp
    }()
    fileprivate lazy var vBtnCycleTimer : UIButton = {
        let temp = UIButton()
        temp.frame = CGRect.init(x: 100, y: 300, width: 200, height: 40)
        temp.setTitle("cycleTimer", for: .normal)
        temp.setTitleColor(.red, for: .normal)
        temp.addTarget(self, action: #selector(cycleTimer), for: .touchUpInside)
        return temp
    }()
    fileprivate lazy var vBtnCycleDisplayLink : UIButton = {
        let temp = UIButton()
        temp.frame = CGRect.init(x: 100, y: 400, width: 200, height: 40)
        temp.setTitle("cycleDisplayLink", for: .normal)
        temp.setTitleColor(.red, for: .normal)
        temp.addTarget(self, action: #selector(cycleDisplayLink), for: .touchUpInside)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUp()
    }
    fileprivate func setUp(){
        self.view.addSubview(self.vBtnCycleVC)
        self.view.addSubview(self.vBtnCycleClosure)
        self.view.addSubview(self.vBtnCycleTimer)
        self.view.addSubview(self.vBtnCycleDisplayLink)
    }
    @objc func cycleVC(){
        self.strongVC = self
    }
    @objc func cycleClosure(){
        self.closureOfTest = {print(self)}
    }
    @objc func cycleTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(actionOfTimer), userInfo: nil, repeats: true)
    }
    @objc func actionOfTimer(){
        print("timer action")
    }

    @objc func cycleDisplayLink(){
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(actionOfDisplayLink))
        self.displayLink?.add(to: .current, forMode: .common)
    }
    @objc func actionOfDisplayLink(){
        print("displayLink action")
    }
    deinit{
        print("deinit \(self)")
    }
}



