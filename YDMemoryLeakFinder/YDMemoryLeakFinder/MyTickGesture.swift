//
//  MyTickGesture.swift
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2023/3/17.
//

/*
 Only the first finger to touch the screen is tracked. All others are ignored.

 The touch always moves left to right.

 The touch moves downward initially but then changes direction and moves upward.

 The upward stroke ends higher on the screen than the initial touch point.
 */




import Foundation
//import UIKit.UIGestureRecognizerSubclass

enum TickPhases {
    case notStarted
    case initialPoint
    case downStroke
    case upStroke
}

class MyTickGesture:UIGestureRecognizer{
    var strokePhase : TickPhases = .notStarted
    var initialTouchPoint : CGPoint = .zero
    var trackedTouch : UITouch? = nil
    
    var tolerance : CGFloat = 20
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print("gesture touches began")
        if touches.count != 1 {
            self.state = .failed
            print("count failed")
        }
        
        if self.trackedTouch == nil {
            self.trackedTouch = touches.first
            self.strokePhase = .initialPoint
            self.initialTouchPoint = self.trackedTouch?.location(in: self.view) ?? .zero
        }else{
            for touch in touches {
                if touch != self.trackedTouch{
                    self.ignore(touch, for: event)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        print("gesture touches moved")
        let newTouch = touches.first
        guard newTouch == self.trackedTouch else {
            self.state = .failed
            print("new touch failed")
            return
        }
        let newPoint = newTouch?.location(in: self.view) ?? .zero
        let previousPoint = newTouch?.previousLocation(in: self.view) ?? .zero
        
        if self.strokePhase == .initialPoint{
            if newPoint.x >= initialTouchPoint.x - self.tolerance && newPoint.y >= initialTouchPoint.y - self.tolerance{
                self.strokePhase = .downStroke
            }else{
                print("initial failed initialPoint = \(initialTouchPoint),newpoint = \(newPoint)")
                self.state = .failed
            }
        }else if self.strokePhase == .downStroke{
            if newPoint.x >= previousPoint.x - self.tolerance{
                if newPoint.y - self.tolerance < previousPoint.y{
                    self.strokePhase = .upStroke
                }
            }else{
                self.state = .failed
                print("downStroke failed previousPoint = \(previousPoint),newpoint = \(newPoint)")
            }
        }else if self.strokePhase == .upStroke{
            if newPoint.x < previousPoint.x - self.tolerance || newPoint.y > previousPoint.y + self.tolerance{
                self.state = .failed
                print("upStroke failed previousPoint = \(previousPoint),newpoint = \(newPoint)")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        print("gesture touches ended")
        let newTouch = touches.first
        let newPoint = newTouch?.location(in: self.view) ?? .zero
        guard newTouch == self.trackedTouch else {
            self.state = .failed
            print("newTouch not failed")
            return
        }
        if self.state == .possible &&
            self.strokePhase == .upStroke &&
            newPoint.y < initialTouchPoint.y + self.tolerance{
            self.state = .recognized
        }else{
            print("state possible failed initialpoint = \(initialTouchPoint),newpoint = \(newPoint)")
            self.state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        print("gesture touches cancelled")
        self.initialTouchPoint = .zero
        self.strokePhase = .notStarted
        self.trackedTouch = nil
        self.state = .cancelled
    }
    
    override func reset() {
        super.reset()
        self.initialTouchPoint = .zero
        self.strokePhase = .notStarted
        self.trackedTouch = nil
    }
}
