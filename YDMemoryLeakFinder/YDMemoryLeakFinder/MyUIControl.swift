//
//  MyUIControl.swift
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/3/20.
//

import Foundation
import UIKit

var tempEvent : UIEvent?
class MyUIControl:UIControl{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        print("touches began",touches.first?.gestureRecognizers?.first)
//        if let upEvent = tempEvent {
//            self.next?.touchesBegan(upEvent.allTouches ?? Set<UITouch>(), with: upEvent)
//        }else{
//            tempEvent = event
//        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
//        print("touches moved")
//        if let upEvent = tempEvent {
//            self.next?.touchesMoved(upEvent.allTouches ?? Set<UITouch>(), with: upEvent)
//        }else{
//            tempEvent = event
//        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
//        print("touches ended",touches.first?.gestureRecognizers?.first)
//        if let upEvent = tempEvent {
//            self.next?.touchesEnded(upEvent.allTouches ?? Set<UITouch>(), with: upEvent)
//        }else{
//            tempEvent = event
//        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("touches cancelled")
//        if let upEvent = tempEvent {
//            self.next?.touchesCancelled(upEvent.allTouches ?? Set<UITouch>(), with: upEvent)
//        }else{
//            tempEvent = event
//        }
    }
    
    
    //用来寻找最合适控件的方法
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let temp = super.hitTest(point, with: event)
        return temp
    }

    //将自身可响应的点击范围向四周扩大20个点
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extend : CGFloat = 20
        if  0 - extend < point.x  && point.x < self.bounds.maxX + extend
                && 0 - extend < point.y && point.y < self.bounds.maxY + extend{
            return true
        }
        return false
    }
}
