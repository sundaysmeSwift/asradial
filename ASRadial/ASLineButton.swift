//
//  ASLineButton.swift
//  ASRadial
//
//  Created by administrator on 2021/7/14.
//  Copyright © 2021 alperSenyurt. All rights reserved.
//

import UIKit

protocol ASLineButtonDelegate:AnyObject{
    
    func buttonDidFinishAnimation(lineButton : UIButton?)
}

class ASLineButton: UIButton{
    var centerPoint:CGPoint!
    var originPoint:CGPoint!
    var bouncePoint:CGPoint!
    var content: Any?
    weak var delegate:ASLineButtonDelegate?
    
    func willAppear () {
        self.alpha                = 1.0
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveEaseInOut) { [weak self] () -> Void in
            self!.center = self!.centerPoint
        } completion: { [weak self](finished:Bool) ->Void in
//            UIView.animate(withDuration: 0.15, animations: { () -> Void in
//                self.center = self.centerPoint
//            })
            self!.center = self!.centerPoint
        }
    }
    
    func willDisappear () {
        
        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveLinear) { [weak self] () -> Void in
            self?.center = self!.originPoint
        } completion: { [weak self](finished:Bool) ->Void in
            self?.alpha = 1
            self?.center = self!.originPoint
            self?.delegate?.buttonDidFinishAnimation(lineButton: self)
        }
        
    }
}
