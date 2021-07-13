//
//  ViewController.swift
//  ASRadial
//
//  Created by Alper Senyurt on 1/5/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    var radialMenu:ASRadialMenu!
    var lineMenu:ASLineMenu!
    
    @IBOutlet weak var button: UIButton!
    var button2: ASLineButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.radialMenu = ASRadialMenu()
//        self.radialMenu.delegate = self
        button2 = ASLineButton.init(frame: CGRect.init(x: 300, y: 100, width: 40, height: 40))
        button2.setTitle("2222", for: .normal)
        button2.setTitleColor(UIColor.red, for: .normal)
        view.addSubview(button2)
        self.button2.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        self.lineMenu = ASLineMenu.init(frame: self.button.frame)
        self.lineMenu.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction
    @objc func buttonPressed(sender: AnyObject) {
        
//        self.radialMenu.buttonsWillAnimateFromButton(sender: sender as! UIButton, frame: self.button.frame, view: self.view)
        
        
        if let button = sender as? ASLineButton {
            let tframe = button.frame
            print("tframe: \(tframe.debugDescription)")
            self.lineMenu.buttonsWillAnimateFromButton(sender: sender as AnyObject, frame: button.frame, view: self.view)
        }
        
        
        
    }
    
   
    

}

extension ViewController:ASLineMenuDelegate {
    func numberOfItemsInMenu(menu: ASLineMenu) -> NSInteger {
        return 4
    }
    
    func spaceBeetnInMenu(menu: ASLineMenu) -> NSInteger {
        return 10
    }
    
    func objfor(index: NSInteger, in menu: ASLineMenu) -> AnyObject? {
        return "\(index)" as AnyObject
    }
    
    func itemForIndex(in menu: ASLineMenu, index: NSInteger, obj: AnyObject?) -> ASLineButton {
        let titleStr = obj as? String
        let btn = ASLineButton.init()
        btn.setTitle(titleStr, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }
    
    func didSelectItemAtIndex(menu: ASLineMenu, index: NSInteger) {
        
    }
    
    func sizeForItem(in radialMenu: ASLineMenu) -> CGFloat {
        return 40
    }
    
}

extension ViewController: ASRadialMenuDelegate{
    func numberOfItemsInRadialMenu (radialMenu:ASRadialMenu)->NSInteger {
        
        return 6
    }
    
    func arcSizeInRadialMenu (radialMenu:ASRadialMenu)->NSInteger {
        
        return 360
    }
    func arcRadiousForRadialMenu (radialMenu:ASRadialMenu)->NSInteger {
        
        return 80
    }
    func radialMenubuttonForIndex(radialMenu:ASRadialMenu,index:NSInteger)->ASRadialButton {
        
        let button:ASRadialButton = ASRadialButton()
        
        if index == 1 {
            
            button.setImage(UIImage(named: "HowToPlay"), for:.normal)
            
        } else if index == 2 {
            
            button.setImage(UIImage(named: "Invite"), for:.normal)
            
        } else if index == 3 {
            
            button.setImage(UIImage(named: "Leader"), for:.normal)
        }
        if index == 4 {
            
            button.setImage(UIImage(named: "Mail"), for:.normal)
            
        } else if index == 5 {
            
            button.setImage(UIImage(named: "Shop"), for:.normal)
            
        } else if index == 6 {
            
            button.setImage(UIImage(named: "Sound"), for:.normal)
        }
        
        return button
    }
    
    func radialMenudidSelectItemAtIndex(radialMenu:ASRadialMenu,index:NSInteger) {
        
        self.radialMenu.itemsWillDisapearIntoButton(button: self.button)
        
    }
}

