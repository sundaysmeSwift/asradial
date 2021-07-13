//
//  ASRadialButton.swift
//  ASRadial
//
//  Created by Alper Senyurt on 1/5/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import CoreGraphics

protocol ASRadialButtonDelegate:AnyObject{
    
    func buttonDidFinishAnimation(radialButton : ASRadialButton)
}

class ASRadialButton: UIButton {
    
    weak var delegate:ASRadialButtonDelegate?
    var centerPoint:CGPoint!
    var bouncePoint:CGPoint!
    var originPoint:CGPoint!
    
    
    func willAppear () {
        
        
        self.imageView?.transform = CGAffineTransform.identity.rotated(by: 180 / 180 * .pi)
        self.alpha                = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.center               = self.bouncePoint
            self.imageView?.transform = CGAffineTransform.identity.rotated(by: 0/180 * .pi)
            }) { (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                    self.center = self.centerPoint
                })
        }
        
    }
    
    func willDisappear () {
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            if let imageView = self.imageView {
                imageView.transform = CGAffineTransform.identity.rotated(by: -180/180 * .pi)
            }
            
            })  { (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.center = self.originPoint
                    }, completion: { (finished) -> Void in
                        self.alpha = 0
                        self.delegate?.buttonDidFinishAnimation(radialButton: self)
                })        }
        
        
    }
}
