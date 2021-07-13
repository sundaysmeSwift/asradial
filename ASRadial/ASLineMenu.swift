//
//  ASLineMenu.swift
//  ASRadial
//
//  Created by administrator on 2021/7/14.
//  Copyright © 2021 alperSenyurt. All rights reserved.
//

import UIKit

enum ASDirectionType {
    case lineUp
    case lineRight
    case lineDown
    case lineLeft
}

@objc protocol ASLineMenuDelegate:AnyObject {
    
    func numberOfItemsInMenu (menu:ASLineMenu)->NSInteger
    func spaceBeetnInMenu (menu:ASLineMenu)->NSInteger
    func objfor(index:NSInteger,in menu:ASLineMenu)->AnyObject?
    func itemForIndex(in menu:ASLineMenu,index:NSInteger,obj: AnyObject?)->ASLineButton
    func didSelectItemAtIndex(menu:ASLineMenu,index:NSInteger)
    
    @objc optional  func startForLineMenu (radialMenu:ASLineMenu)->NSInteger
    @objc optional  func sizeForItem(in radialMenu:ASLineMenu)->CGFloat
    
}

class ASLineMenu: UIView,ASLineButtonDelegate{
    
    var items:[UIView]! = []
    var animationTimer:Timer?
    weak var delegate:ASLineMenuDelegate?
    var itemIndex:NSInteger = 0
    var directionType: ASDirectionType = .lineLeft
    
    func itemsWillAppear(fromButton:UIButton,frame:CGRect,inView:UIView){
        
        if let tItems = self.items, tItems.count > 0 {
            
            return
        }
        
        if self.animationTimer != nil {
            return
        }
        
        let itemCount:NSInteger = delegate?.numberOfItemsInMenu(menu: self) ?? -1
        
        if itemCount == -1 {
            
            return
        }
        
        let centerX:CGFloat       = frame.origin.x + (frame.size.height/2)
        let centerY:CGFloat        = frame.origin.y + (frame.size.width/2)
        let origin:CGPoint        = CGPoint.init(x: centerX, y: centerY)
        
        
        var buttonSize:CGFloat = 25.0;
        
        if let tSizeForItem = self.delegate?.sizeForItem {
            
            buttonSize         = tSizeForItem(self)
        }
        var curIndex:NSInteger = 0;
        var itemBtn:ASLineButton?;
        var mutablePopup:[UIView] = []
        
        while curIndex <= itemCount {
            let popupButtonframe = CGRect.init(x: centerX-buttonSize*0.5, y: centerY-buttonSize*0.5, width: buttonSize, height: buttonSize)
            var spaceBettenItem = 0
            if let tSizeForItem = self.delegate?.spaceBeetnInMenu {
                
                spaceBettenItem = tSizeForItem(self)
            }
                
            
            let objforItem = self.delegate?.objfor(index: curIndex, in: self)
            itemBtn = self.delegate?.itemForIndex(in: self, index: curIndex, obj: objforItem)
            itemBtn?.frame = popupButtonframe
//
            var x      = centerX
            var y      = centerY
            var extraX = centerX
            var extraY = centerY
            switch directionType {
//            case ASDirectionType.lineLeft:
//                x = centerX - (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex)
            case ASDirectionType.lineRight:
                x = centerX + (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex)
                extraX = round (centerX + (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex));
                
            case ASDirectionType.lineUp:
                y = centerY - (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex)
                extraY = round (centerY - (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex));
            case ASDirectionType.lineDown:
                y = centerY + (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex)
                extraY = round (centerY + (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex));
            default:
                x = centerX - (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex)
                extraX = centerX - (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex)
            }
            
            let final   = CGPoint.init(x: x, y: y)
            let bounce = CGPoint.init(x: extraX, y: extraY)
            itemBtn?.centerPoint = final
            itemBtn?.bouncePoint = bounce
            itemBtn?.originPoint = origin
            itemBtn?.tag         = curIndex
            itemBtn?.delegate    = self
            itemBtn?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            itemBtn?.isSelected = curIndex == fromButton.tag
            itemBtn.map {inView.insertSubview($0, belowSubview: fromButton)}
            itemBtn.map { mutablePopup.append($0)}
            curIndex = +1
            
        }
        self.items     = mutablePopup;
        self.itemIndex = 0;
        let maxDuration:CGFloat = 0.50;
        let flingInterval       = maxDuration/CGFloat(self.items.count);
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(willFlingItem), userInfo: nil, repeats: true)
//        let spinDuration        = CGFloat(self.items.count+1) * flingInterval;
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
//        let spinDuration        = CGFloat(self.items.count + 1) * flingInterval
//        self.shouldRotateButton(button: button, forDuration: spinDuration, forwardDirection: false)
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
    
    @objc func willFlingItem() {
        
        if self.itemIndex == self.items.count {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
            return;
        }
        
        let button = self.items[self.itemIndex] as? ASLineButton
        button?.willAppear()
        self.itemIndex = self.itemIndex + 1
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
    
    @objc func buttonPressed(sender:ASLineButton) {
        if let button = sender as? ASLineButton {
            self.delegate?.didSelectItemAtIndex(menu: self, index: button.tag)
        }
    }
    
    func buttonDidFinishAnimation(lineButton: UIButton?) {
        lineButton?.removeFromSuperview()
        
        if lineButton?.tag == 1 {
            
            self.items = nil
        }
    }
    
}
