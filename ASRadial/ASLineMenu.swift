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

class ASLineMenu: UIView{
    
    var items:[UIView]! = []
    var animationTimer:Timer?
    weak var delegate:ASLineMenuDelegate?
    var itemIndex:NSInteger = 0
    var directionType: ASDirectionType = .lineLeft
    var fromView: UIView?
    var bgView: ASLineBGView?
    
    func itemsWillAppear(fromView originView:UIView?, inView:UIView){
        fromView = originView
        guard let tfromView = originView  else {
            return
        }
        let tFrame = tfromView.frame
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
        
        let centerX:CGFloat       = tFrame.origin.x + (frame.size.height/2)
        let centerY:CGFloat        = tFrame.origin.y + (frame.size.width/2)
        let origin:CGPoint        = CGPoint.init(x: centerX, y: centerY)
        
        
        var buttonSize:CGFloat = 25.0;
        
        if let tSizeForItem = self.delegate?.sizeForItem {
            
            buttonSize         = tSizeForItem(self)
        }
        var curIndex:NSInteger = 0;
        var itemBtn:ASLineButton?;
        var mutablePopup:[UIView] = []
        var spaceBettenItem = 0
        if let tSizeForItem = self.delegate?.spaceBeetnInMenu {
            
            spaceBettenItem = tSizeForItem(self)
        }
        while curIndex <= itemCount {
            let popupButtonframe = CGRect.init(x: centerX-buttonSize*0.5, y: centerY-buttonSize*0.5, width: buttonSize, height: buttonSize)
            
                
            
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
                x = centerX + (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex + 1)
                extraX = round (centerX + (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex + 1));
                
            case ASDirectionType.lineUp:
                y = centerY - (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex + 1)
                extraY = round (centerY - (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex + 1));
            case ASDirectionType.lineDown:
                y = centerY + (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex + 1)
                extraY = round (centerY + (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex + 1));
            default:
                x = centerX - (CGFloat(spaceBettenItem) + buttonSize) * CGFloat(curIndex + 1)
                extraX = centerX - (CGFloat(spaceBettenItem) + buttonSize * 1.07) * CGFloat(curIndex + 1)
            }
            
            let final   = CGPoint.init(x: x, y: y)
            let bounce = CGPoint.init(x: extraX, y: extraY)
            itemBtn?.centerPoint = final
            itemBtn?.bouncePoint = bounce
            itemBtn?.originPoint = origin
            itemBtn?.tag         = curIndex
            itemBtn?.delegate    = self
            itemBtn?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            itemBtn?.isSelected = curIndex == tfromView.tag
            itemBtn.map {inView.insertSubview($0, belowSubview: tfromView)}
            itemBtn.map { mutablePopup.append($0)}
            curIndex = curIndex + 1
            
        }
        self.items     = mutablePopup;
        
        var bgWidth: CGFloat = 0
        var bgHeight: CGFloat = 0
        var tcenter:CGPoint = CGPoint.zero
        switch directionType {
        case .lineDown:
            bgWidth = buttonSize + 6
            bgHeight = CGFloat(self.items.count) * (CGFloat(spaceBettenItem) + buttonSize)
            let tcenterY:CGFloat = tFrame.origin.y + tFrame.size.height + CGFloat(spaceBettenItem) + bgHeight / 2.0
            tcenter = CGPoint.init(x: centerX, y: tcenterY)
        case .lineUp:
            bgWidth = buttonSize + 6
            bgHeight = CGFloat(self.items.count) * (CGFloat(spaceBettenItem) + buttonSize)
            let tcenterY:CGFloat = tFrame.origin.y - CGFloat(spaceBettenItem) - bgHeight / 2.0
            tcenter = CGPoint.init(x: centerX, y: tcenterY)
        case .lineRight:
            bgHeight = buttonSize + 6
            bgWidth = CGFloat(self.items.count) * (CGFloat(spaceBettenItem) + buttonSize)
            let tcenterX:CGFloat = tFrame.origin.x + tFrame.size.width + CGFloat(spaceBettenItem) + bgWidth / 2.0
            tcenter = CGPoint.init(x: tcenterX, y: centerY)
        default:
            bgHeight = buttonSize + 6
            bgWidth = CGFloat(self.items.count) * (CGFloat(spaceBettenItem) + buttonSize)
            let tcenterX:CGFloat = tFrame.origin.x - CGFloat(spaceBettenItem) - bgWidth / 2.0
            tcenter = CGPoint.init(x: tcenterX, y: centerY)
        }
        let bgViewOriginFrame = CGRect.init(x: 0, y: 0, width: buttonSize, height: buttonSize)
        let bgViewNewFrame =  CGRect.init(x: 0, y: 0, width: bgWidth, height: bgHeight)
        self.bgView = ASLineBGView.init(frame: bgViewOriginFrame)
        self.bgView?.center = origin
//        self.bgView?.layer.borderWidth = 1
//        self.bgView?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.bgView?.layer.cornerRadius = buttonSize / 2.0
        self.bgView?.layer.masksToBounds = true
        self.bgView?.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.86)
        self.bgView?.centerPoint = tcenter
        self.bgView.map {
            inView.insertSubview($0, belowSubview: tfromView)
        }
        let maxDuration:CGFloat = 0.20;
        UIView.animate(withDuration: TimeInterval(maxDuration)) {[weak self] in
            self?.bgView?.frame = bgViewNewFrame
            self?.bgView?.center = tcenter
        } completion: { [weak self] (finished: Bool) in
            self?.bgView?.frame = bgViewNewFrame
            self?.bgView?.center = tcenter
        }

        
        self.itemIndex = 0;
        
        let flingInterval       = maxDuration/CGFloat(self.items.count);
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(willFlingItem), userInfo: nil, repeats: true)
//        let spinDuration        = CGFloat(self.items.count+1) * flingInterval;
    }
    
    func itemsWillDisapearInto(inView toView: UIView?) {
        
        if self.items?.count == 0 {
            
            return
        }
        
        if let animation =  self.animationTimer  {
            
            animation.invalidate()
            self.animationTimer = nil
            self.itemIndex      = self.items.count
        }
        if let tview = toView {
            let center = tview.center
            for item in self.items {
                let itemView = item as? ASLineButton
                itemView?.originPoint = center
            }
        }
        let maxDuration:CGFloat = 0.50
        UIView.animate(withDuration: TimeInterval(maxDuration), delay: 0.3, options: UIView.AnimationOptions.curveLinear) {[weak self] in
            self?.bgView?.frame = .zero
            if let tcenter = toView?.center{
                self?.bgView?.center = tcenter
            }
        } completion: { [weak self] (finished: Bool) in
            self?.bgView?.removeFromSuperview()
            self?.bgView = nil
        }

//        UIView.animate(withDuration: TimeInterval(maxDuration)) {[weak self] in
//            self?.bgView?.frame = .zero
//            if let tcenter = toView?.center{
//                self?.bgView?.center = tcenter
//            }
//        } completion: { [weak self] (finished: Bool) in
//            self?.bgView?.removeFromSuperview()
//            self?.bgView = nil
//        }


        
        
        let flingInterval       = maxDuration / CGFloat(self.items.count)
        
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(willRecoilItem), userInfo: nil, repeats: true)
//        let spinDuration        = CGFloat(self.items.count + 1) * flingInterval
//        self.shouldRotateButton(button: button, forDuration: spinDuration, forwardDirection: false)
    }
    
    func buttonsWillAnimatefrom(sender:AnyObject,inToView originView:UIView){
        
        if self.animationTimer != nil {
            
            return
        }
        if let tItems = self.items,tItems.count > 0 {
            
            self.itemsWillDisapearInto(inView: sender as? UIView)
        } else {
            self.itemsWillAppear(fromView: sender as? UIView, inView: originView)
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
        
        let button = self.items[self.itemIndex] as? ASLineButton
        button?.willDisappear()
        
    }
    
    @objc func buttonPressed(sender:ASLineButton) {
        self.delegate?.didSelectItemAtIndex(menu: self, index: sender.tag)
        self.itemsWillDisapearInto(inView: sender as UIView)
    }
    
}


extension ASLineMenu: ASLineButtonDelegate {//, ASLineBGDelegate
    func buttonDidFinishAnimation(lineButton: UIView?) {
        lineButton?.removeFromSuperview()
        if self.items != nil {
            self.items = nil
        }
//        if lineButton?.tag == 1 {
//            self.items = nil
//        }
    }
}
