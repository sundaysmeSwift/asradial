//
//  ASRadialMenu.swift
//  ASRadial
//
//  Created by Alper Senyurt on 1/5/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit

@objc protocol ASRadialMenuDelegate:AnyObject {
    
    func numberOfItemsInRadialMenu (radialMenu:ASRadialMenu)->NSInteger
    func arcSizeInRadialMenu (radialMenu:ASRadialMenu)->NSInteger
    func arcRadiousForRadialMenu (radialMenu:ASRadialMenu)->NSInteger
    func radialMenubuttonForIndex(radialMenu:ASRadialMenu,index:NSInteger)->ASRadialButton
    func radialMenudidSelectItemAtIndex(radialMenu:ASRadialMenu,index:NSInteger)
    
    @objc optional  func arcStartForRadialMenu (radialMenu:ASRadialMenu)->NSInteger
    @objc optional  func buttonSizeForRadialMenu (radialMenu:ASRadialMenu)->CGFloat
    
    
    
    
}
class ASRadialMenu: UIView,ASRadialButtonDelegate{
    
    var items:[UIView]! = []
    var animationTimer:Timer?
    weak var delegate:ASRadialMenuDelegate?
    var itemIndex:NSInteger = 0
    
    func itemsWillAppear(fromButton:UIButton,frame:CGRect,inView:UIView){
        
        if let tItems = self.items, tItems.count > 0 {
            
            return
        }
        
        if self.animationTimer != nil {
            return
        }
        
        let itemCount:NSInteger = delegate?.numberOfItemsInRadialMenu(radialMenu: self) ?? -1
        
        if itemCount == -1 {
            
            return
        }
        
        var mutablePopup:[UIView]    = []
        let arc:NSInteger            = self.delegate?.arcSizeInRadialMenu(radialMenu: self) ?? 90
        var radius:NSInteger         = self.delegate?.arcRadiousForRadialMenu(radialMenu: self) ?? 80
        var start:NSInteger          = 0
        
        if let respondArcStartMethod = self.delegate?.arcStartForRadialMenu {
            
            start          = respondArcStartMethod(self)
        }
        
        var  angle:CGFloat = 0
        
        if arc>=360 {
            
            angle         = CGFloat(360)/CGFloat(itemCount)
            
        } else if itemCount>1 {
            
            angle         = CGFloat(arc)/CGFloat((itemCount-1))
        }
        let centerX       = frame.origin.x + (frame.size.height/2);
        let centerY       = frame.origin.y + (frame.size.width/2);
        let origin        = CGPoint.init(x: centerX, y: centerY)
           
        
        var buttonSize:CGFloat = 25.0;
        
        if let respondbuttonSizeForRadialMenuMethod = self.delegate?.buttonSizeForRadialMenu {
            
            buttonSize         = respondbuttonSizeForRadialMenuMethod(self)
        }
        
        var currentItem:NSInteger = 1;
        var popupButton:ASRadialButton?;
        
        
        while currentItem <= itemCount {
            
            var radians = (angle * (CGFloat(currentItem) - 1.0) + CGFloat(start)) * (CGFloat(M_PI)/CGFloat(180))
            
            let x      = round (centerX + CGFloat(radius) * cos(CGFloat(radians)));
            let y      = round (centerY + CGFloat(radius) * sin(CGFloat(radians)));
            let extraX = round (centerX + (CGFloat(radius)*1.07) * cos(CGFloat(radians)));
            let extraY = round (centerY + (CGFloat(radius)*1.07) * sin(CGFloat(radians)));
            
            let popupButtonframe = CGRect.init(x: centerX-buttonSize*0.5, y: centerY-buttonSize*0.5, width: buttonSize, height: buttonSize)
               
            let final   = CGPoint.init(x: x, y: y)
            let bounce  = CGPoint.init(x: extraX, y: extraY)
            popupButton = self.delegate?.radialMenubuttonForIndex(radialMenu: self, index: currentItem)
            popupButton?.frame = popupButtonframe
            popupButton?.centerPoint = final
            popupButton?.bouncePoint = bounce
            popupButton?.originPoint = origin
            popupButton?.tag         = currentItem
            popupButton?.delegate    = self
            popupButton?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            popupButton.map {inView.insertSubview($0, belowSubview: fromButton)}
            popupButton.map { mutablePopup.append($0)}
            currentItem = +1
            
        }
        
        self.items     = mutablePopup;
        self.itemIndex = 0;
        let maxDuration:CGFloat = 0.50;
        let flingInterval       = maxDuration/CGFloat(self.items.count);
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(willFlingItem), userInfo: nil, repeats: true)
        let spinDuration        = CGFloat(self.items.count+1) * flingInterval;
        self.shouldRotateButton(button: fromButton, forDuration: spinDuration, forwardDirection: false)
        
        
    }
    
    
    func itemsWillDisapearIntoButton(button:UIButton) {
        
        if self.items?.count == 0 {
            
            return
        }
        
        if let animation =  self.animationTimer  {
            
            animation.invalidate()
            self.animationTimer = nil
            self.itemIndex      = self.items.count
        }
        
        let maxDuration:CGFloat = 0.50
        let flingInterval       = maxDuration / CGFloat(self.items.count)
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(willRecoilItem), userInfo: nil, repeats: true)
        let spinDuration        = CGFloat(self.items.count + 1) * flingInterval
        self.shouldRotateButton(button: button, forDuration: spinDuration, forwardDirection: false)
    }
    
    func buttonsWillAnimateFromButton(sender:AnyObject,frame:CGRect,view:UIView){
        
        if self.animationTimer != nil {
            
            return
        }
        if let tItems = self.items,tItems.count > 0 {
            
            self.itemsWillDisapearIntoButton(button: sender as! UIButton)
        } else {
            
            self.itemsWillAppear(fromButton: sender as! UIButton, frame: frame, inView: view)
        }
    }
    
    func shouldRotateButton(button:UIButton,forDuration:CGFloat, forwardDirection:Bool) {
        
        let spinAnimation            = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.duration       = Double(forDuration)
        spinAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        var totalDuration            = CGFloat(M_PI) * CGFloat(self.items.count)
       
        if forwardDirection {
            
            totalDuration = totalDuration * -1
        }
        spinAnimation.toValue = NSNumber(value:Float(totalDuration))
        button.layer.add(spinAnimation, forKey: "spinAnimation")
    }
    
    @objc func willRecoilItem() {
       
        if self.itemIndex == 0 {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
            return;
        }
        self.itemIndex = self.itemIndex - 1
        
        let button = self.items[self.itemIndex] as! ASRadialButton
        button.willDisappear()
        
    }
    @objc func willFlingItem() {
        
        if self.itemIndex == self.items.count {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
            return;
        }
        
        let button = self.items[self.itemIndex] as? ASRadialButton
        button?.willAppear()
        self.itemIndex = self.itemIndex + 1
    }
    
    @objc func buttonPressed(sender:AnyObject) {
       
        if let button = sender as? ASRadialButton {
            self.delegate?.radialMenudidSelectItemAtIndex(radialMenu: self, index: button.tag)
        }
        
        
    }
    
    func buttonDidFinishAnimation(radialButton : ASRadialButton) {
        
        radialButton.removeFromSuperview()
        
        if radialButton.tag == 1 {
            
            self.items = nil
        }
    }
    
}
