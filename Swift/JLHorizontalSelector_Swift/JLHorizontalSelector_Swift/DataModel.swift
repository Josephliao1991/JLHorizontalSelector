//
//  DataModel.swift
//  JLHorizontalSelector_Swift
//
//  Created by TSUNG-LUN LIAO on 2015/6/18.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//


import UIKit
//import Cocoa

protocol DataModelDelegate{
    
    
    
}

class DataModel: NSObject {
    
    var title:NSString
    
    init(title:NSString) {
        
        self.title = title
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
