//
//  ASLineBGView.swift
//  ASRadial
//
//  Created by Biggerlens on 2021/7/14.
//  Copyright © 2021 alperSenyurt. All rights reserved.
//

import UIKit

protocol ASLineBGDelegate:AnyObject{
    
    func buttonDidFinishAnimation(lineButton : UIView?)
}
class ASLineBGView: UIView {
    var centerPoint:CGPoint!
    var originPoint:CGPoint!
    weak var delegate:ASLineBGDelegate?
    override init(frame:CGRect){
       super.init(frame: frame)
   }
   
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   
   override func layoutSubviews() {
       super.layoutSubviews()
   }
    
//    func willAppear () {
//        self.alpha                = 1.0
//        
//        UIView.animate(withDuration: 0.5) {[weak self] in
//            self!.center = self!.centerPoint
//        } completion: { [weak self] (finished: Bool) -> Void in
//            self!.center = self!.centerPoint
//        }
//
//    }
//    
//    func willDisappear () {
//        UIView.animate(withDuration: 0.5) {[weak self] in
//            self!.center = self!.originPoint
//        } completion: { [weak self] (finished: Bool) -> Void in
//            self!.center = self!.originPoint
//            self?.alpha = 1
//            self?.delegate?.buttonDidFinishAnimation(lineButton: self)
//        }
//    }
}
