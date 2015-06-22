//
//  ControlView.swift
//  JLHorizontalSelector_Swift
//
//  Created by TSUNG-LUN LIAO on 2015/6/18.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//


import UIKit
//import Cocoa


protocol ControlViewDelegate{
    
    
    func controlView(controlView:ControlView?, didBeginTouch touches:NSSet?)
    func controlView(controlView:ControlView?, didMoveTouch  touches:NSSet?)
    func controlView(controlView:ControlView?, didStopTouch  touches:NSSet?)

}

class ControlView: UIView {
    
// MARK: Private Variable
    private var deleagte        :ControlViewDelegate?
    private var theImageView    :UIImageView!

    init(imageName:NSString, delegate:AnyObject){
        
        super.init(frame: CGRectMake(CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0)))
        
        self.deleagte = delegate as? ControlViewDelegate
        
        self.theImageView = UIImageView(image: UIImage(named: imageName as String))
        self.frame = self.theImageView.frame
        
        //Add ImageView
        self.addImageView()
        
        
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    
    func addImageView(){
        
        self.addSubview(self.theImageView)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints_Top:NSLayoutConstraint = NSLayoutConstraint(
            item: self.theImageView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0)
        
        let constraints_Bottom:NSLayoutConstraint = NSLayoutConstraint(
            item: self.theImageView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0)
        
        let constraints_Left:NSLayoutConstraint = NSLayoutConstraint(
            item: self.theImageView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0)
        
        let constraints_Right:NSLayoutConstraint = NSLayoutConstraint(
            item: self.theImageView,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0)
        
        self.addConstraints([constraints_Top,constraints_Bottom,constraints_Left,constraints_Right])
        
        self.theImageView.layer.cornerRadius = (self.theImageView.frame.size.width+self.theImageView.frame.size.height)/4
        self.theImageView.clipsToBounds = true
        
    }

// MARK: - Touch Event
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        
        NSLog("Start Selector")
        self.deleagte!.controlView(self, didBeginTouch: touches)
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent?) {
        
        NSLog("Move...")
        self.deleagte!.controlView(self, didMoveTouch: touches)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?) {
        
        NSLog("Select Done")
        self.deleagte!.controlView(self, didStopTouch: touches)
        
    }


}
