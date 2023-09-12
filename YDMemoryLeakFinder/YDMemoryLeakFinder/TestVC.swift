//
//  TestVC.swift
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/1/11.
//

import UIKit


@objcMembers
class TestModel:Codable{
    var name : String?
    var age : Int?
}

class SubTestModel:TestModel{
    var newName : String?
//    override func encode(to encoder: Encoder) throws {
//        try super.encode(to: encoder)
//        newName = encoder.container(keyedBy: CodingKeys)
//    }
}

class TestView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    override func draw(_ rect: CGRect) {

    }

}

class TestLayer : CALayer{
    override func action(forKey event: String) -> CAAction? {
        let temp = super.action(forKey: event)
        print("action forkey = ",temp)
        
        return temp
    }
    override class func defaultAction(forKey event: String) -> CAAction? {
        let temp = super.defaultAction(forKey: event)
        print("action event = ",temp)
        return temp
    }
}

protocol Pointer_Protocol {
    func pointer()->UnsafeRawPointer
    mutating func mutablePointer()->UnsafeMutableRawPointer
}
extension Pointer_Protocol{
    func pointer()->UnsafeRawPointer{
        withUnsafePointer(to: self) { ptr in
            return UnsafeRawPointer.init(ptr)
        }
    }
    mutating func mutablePointer()->UnsafeMutableRawPointer{
        withUnsafeMutablePointer(to: &self) { ptr in
            return UnsafeMutableRawPointer.init(ptr)
        }
    }
}


extension Int : Pointer_Protocol{}

@objcMembers
class TestVC: UIViewController,UIScrollViewDelegate,CAAnimationDelegate{
    static var tempY : CGFloat = 10
     var strongVCPrivate : TestVC?
    var strongVC : TestVC?
    var closureOfTest = {}
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
    }
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
    }
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addBtn()
        self.addGesture()
        self.addMyControl()
        self.strongVCPrivate = self;
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func testOutOfScreen(){
        let view1 = UIView()
        view1.frame = .init(x: 200, y: 200, width: 150, height: 150)
//        view1.layer.cornerRadius = 20
        view1.clipsToBounds = true
//        view1.backgroundColor = .lightGray
//        view1.layer.contents = UIImage(named: "test_img.png")?.cgImage
        
        let maskView = TestView()
        maskView.frame = .init(x: 25, y: 25, width:50 , height: 50)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view1.bounds
        
        let path = UIBezierPath()
        path.move(to: .init(x: 0, y: 0))
        path.addLine(to: .init(x: 50, y: 50))
        path.addLine(to: .init(x: 0, y: 50))
        path.close()
        maskLayer.path = path.cgPath
        
//        view1.layer.mask = maskLayer
        
        self.view.addSubview(view1)
    }
    
    func animationTest(){
        var aniView = TestView()
        aniView.tag = 100
        if let temp = self.view.viewWithTag(100) as? TestView{
            aniView = temp
        }
        aniView.frame = .init(x: 100, y: 100, width: 100, height: 100)
        aniView.backgroundColor = .lightGray
        self.view.addSubview(aniView)
        
        
        let newPosition = CGPoint.init(x: 200, y: 200)
        let baseAni = CABasicAnimation()
        baseAni.delegate = self
        baseAni.duration = 2
        baseAni.toValue = NSValue(cgPoint: newPosition)
        
//        aniView.layer.add(baseAni, forKey: "position")
        
        
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
    func actionTimer(){
        
    }
    
}






extension TestVC{
    fileprivate func addBtn(){
        let btn = UIButton.init(type: .custom)
        btn.frame = .init(x: 100, y: 100, width: 100, height: 30)
        btn.setTitle("test btn", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(actionOfTestBtn), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    fileprivate func addGesture(){
        let lab = UILabel()
        lab.text = "test gesture"
        lab.textColor = .red
        lab.frame = .init(x: 100, y: 300, width: 100, height: 30)
        lab.isUserInteractionEnabled = true
        self.view.addSubview(lab)
        
        lab.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(actionOfTestGesture)))
    }
    
    fileprivate func addMyControl(){
        let control = MyUIControl()
        control.tag = 101
        control.backgroundColor = .lightGray
        control.frame = .init(x: 100, y: 400, width: 200, height: 200)
        control.addTarget(self, action: #selector(actionOfControl), for: .touchUpInside)
        
        let control1 = MyUIControl()
        control1.tag = 100
        control1.backgroundColor = .systemPink
        control1.frame = .init(x: 0, y: 0, width: 100, height: 100)
        control1.isUserInteractionEnabled = false
        
//        control1.addTarget(self, action: #selector(actionOfControl1), for: .touchUpInside)
        control.addSubview(control1)

        self.view.addSubview(control)
    }
    
    fileprivate func addMyTickGesture(){
        let temp  = self.view.viewWithTag(101)
        temp?.addGestureRecognizer(MyTickGesture.init(target: self, action: #selector(actionOfTick)))
    }
    
    @objc func actionOfTestGesture(){
        print("test gesture")
    }
    @objc func actionOfTestBtn(){
        print("test btn")
    }
    @objc func actionOfControl(){
        print("test control")
    }
    @objc func actionOfControl1(){
        print("test control1")
    }
    
    @objc func actionOfTick(){
        print("---------------------------------tick recognized")
        let lab = UILabel()
        lab.text = "✅"
        lab.font = .systemFont(ofSize: 40)
        lab.sizeToFit()
        lab.center = self.view.center
        self.view.addSubview(lab);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            lab.removeFromSuperview()
        }
        
    }
}

/// 测试
typealias Test1 = TestClass1

typealias Test2 = TestClass2

protocol Initializable{
    init()
}


class TestClass1:Initializable{
    required init(){
    }
}
class TestClass2:Initializable{
    required init(){
    }
}

