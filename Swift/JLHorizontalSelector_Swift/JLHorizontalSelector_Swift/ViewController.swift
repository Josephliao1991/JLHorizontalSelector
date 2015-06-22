//
//  ViewController.swift
//  JLHorizontalSelector_Swift
//
//  Created by TSUNG-LUN LIAO on 2015/6/18.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

import UIKit


class ViewController: UIViewController,JLHorizontalSelectordelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        let horizontal = JLHorizontalSelector(
            frame:self.view.frame,
            objects: [["title":"iPhone 1"],["title":"iPhone 2"],["title":"iPhone 3"],["title":"iPhone4"]],
            imageName: "Start.png",
            delegate: self)

        horizontal.titleColor = UIColor.whiteColor()
        
        horizontal.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
// MARK: JLHorizontalDelegate
    func horizontalSelector(horizontalSelector: JLHorizontalSelector!, didSelectItemOfIndex index: NSInteger) {
        //
        NSLog("%d", index);
        
        switch index {
            
        case 0 :
            
            self.view.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 0.8)
            
            break;
            
        case 1 :
            
            self.view.backgroundColor = UIColor(hue: 0.8, saturation: 0.8, brightness: 0.4, alpha: 0.7)
            
            break;
            
        case 2 :
            
            self.view.backgroundColor = UIColor.blueColor()
            
            break;
            
        case 3 :
            
            self.view.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.3, alpha: 0.8)
            
            break;
            
        default :
            
            break;
            
        }
        
        
        
        
    }

}

