//
//  JLHorizontalSelector.h
//  JLHorizontalSelector
//
//  Created by TSUNG-LUN LIAO on 2015/6/12.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLHorizontalSelector;

@protocol JLHorizontalSelectorDelegate <NSObject>

@required

- (void)horizontalSelector:(JLHorizontalSelector*)horizontalSelector didSelectItemOfIndex:(NSInteger)index;

@end

@interface JLHorizontalSelector : UIView

//item
@property (nonatomic) UIColor   *titleColor;
@property (nonatomic) UIColor   *itemColor;

//Move View
@property (nonatomic) UIColor   *moveViewColor;
@property (nonatomic) CGSize    moveViewSize;

+ (JLHorizontalSelector*)creatSeletcorWithObjects:(NSArray*)objects withStartImageName:(NSString*)imageName withDelegate:(id)delegate;

- (void)show;

@end
