//
//  JLHorizontalSelector.swift
//  JLHorizontalSelector_Swift
//
//  Created by TSUNG-LUN LIAO on 2015/6/18.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

import UIKit
//import Cocoa

enum selectorDirection{
    
    case Up    //default is Up
    case Down

}

enum selectorAnimation{
    
    case Alpha//default is Alpha
    case None
    
}

protocol JLHorizontalSelectordelegate{
    
    func horizontalSelector(horizontalSelector:JLHorizontalSelector!, didSelectItemOfIndex index:NSInteger)
    
}


class JLHorizontalSelector: UIView, UITableViewDataSource, UITableViewDelegate, ControlViewDelegate{

// MARK: -
// MARK: Public Variable
    
    //selector Direction
    var direction:selectorDirection!

    //selector Animation
    var animation:selectorAnimation!
    
    //item
    var titleColor:UIColor!
    var itemColor :UIColor!
    
    //Move View
    var moveViewColor:UIColor!
    var moveViewSize :CGSize!
    
// MARK: Private Variable
    
    private var delegate:JLHorizontalSelectordelegate!  //Delegate Property
    
    private var tableView       :UITableView!
    private var data            :NSMutableArray!
    
    private var moveView        :UIView!
    
    private var controlView     :ControlView!
    private var imageName       :NSString!

// MARK: -
    
    init(frame:CGRect, objects:NSArray, imageName:NSString, delegate:AnyObject){
        
        //size set
        let size:CGSize = CGSizeMake(frame.size.width, frame.size.height)
        super.init(frame: CGRect(x: -size.width/3, y: 0, width: size.width/3, height: size.height))
        
        
        self.delegate = delegate as! JLHorizontalSelectordelegate
        
        //set data
        self.data = []
        
        for obj in objects{
            
            let dic = obj as! NSDictionary
            
            let dataModel:DataModel = DataModel(title: dic.objectForKey("title") as! NSString)
            
            self.data.addObject(dataModel)
            
        }
        
        //set imageName
        self.imageName = imageName
        
        //set MoveView
        self.moveViewColor  =   UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 0.7)
        self.moveViewSize   =   CGSizeMake(60, 60);
        
        //set item
        self.itemColor      =   UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 0.9)
        self.titleColor     =   UIColor.whiteColor()
        
        //set selector animation type
        self.animation      =   selectorAnimation.Alpha
        
        //set selector direction
        self.direction      =   selectorDirection.Up
        
        //add NotificationCenter to Handler App EnterBackground
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"resetView:", name: UIApplicationDidEnterBackgroundNotification, object: UIApplication.sharedApplication())
        
        
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit{
        
      NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func show(){
        
        
         let viewController = self.delegate as! ViewController
        
        viewController.view.addSubview(self)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint_Top = NSLayoutConstraint(
            item: self,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: viewController.view,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0)
        
        let constraint_Bottom = NSLayoutConstraint(
            item: self,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: viewController.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0)
        
        let constraint_Width = NSLayoutConstraint(
            item: self,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: viewController.view,
            attribute: .Width,
            multiplier: 0.3333,
            constant: 0)
        
        let constraint_Left = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: viewController.view,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0)
        
        viewController.view!.addConstraints([constraint_Top,constraint_Bottom,constraint_Width,constraint_Left])
        
        self.addTaleView()
        self.addMoveView()
        self.addControlView()
        
    }

// MARK: - Add SubView

    private func addTaleView(){
        
        let rect = CGRectMake(CGFloat(0), CGFloat(0), CGFloat(self.frame.size.width), CGFloat(self.data.count*44))
        
        self.tableView = UITableView(frame: rect, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyle.None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.userInteractionEnabled = false
        
        self.addSubview(self.tableView)
        
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint_Top = NSLayoutConstraint(
            item: self.tableView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: self.frame.size.height/2-self.tableView.frame.size.height)
        
        let constraint_Buttom = NSLayoutConstraint(
            item: self.tableView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: self.frame.size.height/2-self.tableView.frame.size.height)
        
        let constraint_Left = NSLayoutConstraint(
            item: self.tableView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0)
        
        let constraint_Right = NSLayoutConstraint(
            item: self.tableView,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0)
        
        self.addConstraints([constraint_Left,constraint_Top,constraint_Buttom,constraint_Right])
        
    }

    func addControlView(){
        
        self.controlView = ControlView(imageName: self.imageName, delegate: self)
        
        let viewController:UIViewController = self.delegate as! UIViewController
        viewController.view.addSubview(self.controlView)
        
        self.controlView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.controlView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint_Buttom = NSLayoutConstraint(
            item: self.controlView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: viewController.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -5)
        
        let constraint_Left = NSLayoutConstraint(
            item: self.controlView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: viewController.view,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 5)
        
        viewController.view.addConstraints([constraint_Buttom,constraint_Left])
        
    }
   
    func addMoveView(){
        
        let viewController:UIViewController = self.delegate as! UIViewController
        
        //set Size
        self.moveView = UIView(frame: CGRectMake(CGFloat(0), CGFloat(0), CGFloat(self.moveViewSize.width), CGFloat(self.moveViewSize.height)))
        self.moveView.layer.cornerRadius = (self.moveViewSize.width + self.moveViewSize.height)/4
        
        self.moveView.backgroundColor = self.moveViewColor
        self.moveView.alpha  =   0
        
        viewController.view.addSubview(self.moveView)
        
        
    }
   
    
// MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        
        cell.textLabel!.textColor = self.titleColor;
        let data:DataModel = self.data[indexPath.row] as! DataModel
        
        cell.textLabel!.text = data.title as String;
        
        cell.backgroundColor = self.itemColor;
        
        
        return cell;
        
    }

    
    //- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    return 20;
    //}
    //
    //- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //    UIView *view = [UIView new];
    //    view.backgroundColor = [UIColor clearColor];
    //    return view;
    //}
    
// MARK: - ControlViewDelegate
    
    func controlView(controlView:ControlView?, didBeginTouch touches:NSSet?){
        
        let viewController:UIViewController = self.delegate as! UIViewController
        
        
        let point:CGPoint = touches!.anyObject()!.locationInView(viewController.view)
        self.moveView.center = point
        
        var row = 0;
        if (self.direction == selectorDirection.Up) {
            row = self.data.count-1;
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //
            self.frame = CGRectMake(0, 0,
                self.frame.size.width,
                self.frame.size.height);
            
            self.moveView.alpha = 1;
            
            self.controlView.alpha = 0.5;
            
            var row = 0;
            if self.direction == selectorDirection.Up {
                row = self.data.count-1;
            }
            
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)
            
            }) { (Bool) -> Void in
                //
                
                
        }

        
    }
    
    func controlView(controlView:ControlView?, didMoveTouch  touches:NSSet?){
        
        let viewController = self.delegate as! UIViewController
        
        let index = self.indexOfItem(touches!) as NSInteger
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated:true, scrollPosition: UITableViewScrollPosition.Top)
        
        let point:CGPoint = touches!.anyObject()!.locationInView(viewController.view)
        self.moveView.center = point
        
        //set animation
        self.selectorAnimatoin(touches!)
        
    }
    
    func controlView(controlView:ControlView?, didStopTouch  touches:NSSet?){
        
        let index = self.indexOfItem(touches!)
        
        self.delegate.horizontalSelector(self, didSelectItemOfIndex: index)
        
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //
            self.frame = CGRectMake(-self.frame.size.width, 0,self.frame.size.width,self.frame.size.height);
            
            self.moveView.alpha = 0;
            self.controlView.alpha = 1;
            self.alpha = 1;
            
            
            }) { (Bool) -> Void in
                //
                self.moveView.center = self.controlView.center;
                
        }
        
    }
    


    
// MARK: - Clean View Method
    
    func resetView(notification: NSNotification){
    
        self.frame = CGRectMake(-self.frame.size.width, 0,
            self.frame.size.width,
            self.frame.size.height);

        self.moveView.alpha = 0;
        self.controlView.alpha = 1;
        self.alpha = 1;

        self.moveView.center = self.controlView.center;
        
    }

// MARK: - Index Cacluate

    func indexOfItem(touches:NSSet) -> NSInteger{
        

        let viewController:UIViewController = self.delegate as! UIViewController
        
        let point:CGPoint = touches.anyObject()!.locationInView(viewController.view)
        
//        //      |           |
//        //    /*|-----------|*\
//        //      |          /|
//        //      |        /  |
//        //  (1)*|------/    | (2)
//        //      |    / |    |
//        //      |  /   |    |
//        //    \*|/_____|____|*/
//        //    (１／４斜邊長 比例 移動)
 
        var rate = Float( (hypot(point.x,viewController.view.frame.size.height-point.y) - self.controlView.frame.size.width*2)/(hypot(viewController.view.frame.size.width, viewController.view.frame.size.height/2)) )
        var count = Float (self.data.count )
        var timeCount = Float( (self.data.count)*2 )
        var indexR = rate * timeCount
        
        if (indexR+1 > count) {
            indexR = count-1;
        }else if (indexR < 0){
            indexR = 0;
        }
        
        //set selector up to down or down to up
        if (self.direction == selectorDirection.Up) {
            indexR = count-indexR-1;
        }
        
        NSLog("Now Select Index %ld",NSInteger (indexR));
        
        return NSInteger ( indexR );
        
    }
    
// MARK: - Selector Animation
    
    func selectorAnimatoin(touches:NSSet){
        
        if (self.animation == selectorAnimation.None) {
            return;
        }
        
        
        let viewController:UIViewController = self.delegate as! UIViewController
        
        if (self.animation == selectorAnimation.Alpha) {
            
            //Alpha animation
            
            let point:CGPoint           = touches.anyObject()!.locationInView(viewController.view)
            let previousPoint:CGPoint   = touches.anyObject()!.previousLocationInView(viewController.view)
            
            let alphaRate_w = 1.25 / viewController.view.frame.size.width
            let alphaRate_h = 1.25 / viewController.view.frame.size.height
 
            if (previousPoint.y > point.y) {
                
                if (self.controlView.alpha>0) {
                    self.controlView.alpha  -= alphaRate_h;
                }
                if (self.alpha>0) {
                    self.alpha              -= alphaRate_h;
                }
                
            }else if(previousPoint.y <= point.y){
                
                if (self.controlView.alpha<1) {
                    self.controlView.alpha  += alphaRate_h;
                }
                if (self.alpha<1) {
                    self.alpha              += alphaRate_h;
                    
                }
                
            }
            
            if (previousPoint.x < point.x) {
                
                if (self.controlView.alpha>0) {
                    self.controlView.alpha  -= alphaRate_w;
                }
                if (self.alpha>0) {
                    self.alpha              -= alphaRate_w;
                }
                
            }else if(previousPoint.x >= point.x){
                
                if (self.controlView.alpha<1) {
                    self.controlView.alpha  += alphaRate_w;
                }
                if (self.alpha<1) {
                    self.alpha              += alphaRate_w;
                    
                }
                
            }
            
        }

    }
    


}

