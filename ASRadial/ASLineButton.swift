//
//  ASLineButton.swift
//  ASRadial
//
//  Created by administrator on 2021/7/14.
//  Copyright © 2021 alperSenyurt. All rights reserved.
//

import UIKit

protocol ASLineButtonDelegate:AnyObject{
    
    func buttonDidFinishAnimation(lineButton : UIView?)
}

class ASLineButton: UIButton{
    var centerPoint:CGPoint!
    var originPoint:CGPoint!
    var bouncePoint:CGPoint!
    var content: Any?
    weak var delegate:ASLineButtonDelegate?
    
    func willAppear () {
        self.alpha                = 1.0
        
//        UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.001, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseInOut) { [weak self] () -> Void in
//            self!.center = self!.centerPoint
//        } completion: { [weak self](finished:Bool) ->Void in
////            UIView.animate(withDuration: 0.15, animations: { () -> Void in
////                self.center = self.centerPoint
////            })
//            self!.center = self!.centerPoint
//        }
        
        UIView.animate(withDuration: 0.5) {[weak self] in
            self!.center = self!.centerPoint
        } completion: { [weak self] (finished: Bool) -> Void in
            self!.center = self!.centerPoint
        }

    }
    
    func willDisappear () {
        
//        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.001, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveLinear) { [weak self] () -> Void in
//            self?.center = self!.originPoint
//        } completion: { [weak self](finished:Bool) ->Void in
//            self?.alpha = 1
//            self?.center = self!.originPoint
//            self?.delegate?.buttonDidFinishAnimation(lineButton: self)
//        }
        UIView.animate(withDuration: 0.5) {[weak self] in
            self!.center = self!.originPoint
        } completion: { [weak self] (finished: Bool) -> Void in
            self!.center = self!.originPoint
            self?.alpha = 1
            self?.delegate?.buttonDidFinishAnimation(lineButton: self)
        }
    }
}


