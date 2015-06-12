//
//  ControlView.h
//  JLHorizontalSelector
//
//  Created by 廖宗綸 on 2015/6/12.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ControlView;

@protocol ControlViewDelegate <NSObject>

@required

- (void)controlView:(ControlView*)controlView didBeginTouch:(NSSet*)touches;
- (void)controlView:(ControlView*)controlView didMoveTouch:(NSSet*)touches;
- (void)controlView:(ControlView*)controlView didStopTouch:(NSSet*)touches;

@end

@interface ControlView : UIView

+ (ControlView*)creatControlViewWithImageName:(NSString*)imageName withDelegate:(id)delegate;

@end
