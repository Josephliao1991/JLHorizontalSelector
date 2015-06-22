//
//  JLHorizontalSelector.h
//  JLHorizontalSelector
//
//  Created by TSUNG-LUN LIAO on 2015/6/12.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, selectorDirection){
    
    selectorDirectionUp,//default is Up
    selectorDirectionDown
    
};

typedef NS_ENUM(NSInteger, selectorAnimation){
    
    selectorDirectionAlpha,//default is Alpha
    selectorDirectionNone
    
};

@class JLHorizontalSelector;

@protocol JLHorizontalSelectorDelegate <NSObject>

@required

- (void)horizontalSelector:(JLHorizontalSelector*)horizontalSelector didSelectItemOfIndex:(NSInteger)index;

@end

@interface JLHorizontalSelector : UIView

//selector Direction
@property (nonatomic) selectorDirection direction;

//selector Animation
@property (nonatomic) selectorAnimation animation;

//item
@property (nonatomic) UIColor   *titleColor;
@property (nonatomic) UIColor   *itemColor;

//Move View
@property (nonatomic) UIColor   *moveViewColor;
@property (nonatomic) CGSize    moveViewSize;

+ (JLHorizontalSelector*)creatSeletcorWithObjects:(NSArray*)objects withStartImageName:(NSString*)imageName withDelegate:(id)delegate;

- (void)show;

@end
