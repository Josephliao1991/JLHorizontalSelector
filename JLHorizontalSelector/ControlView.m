//
//  ControlView.m
//  JLHorizontalSelector
//
//  Created by 廖宗綸 on 2015/6/12.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import "ControlView.h"

@interface ControlView ()

@property (nonatomic, strong) UIImageView *theImageView;
@property (nonatomic, strong) id<ControlViewDelegate> delegate;

@end

@implementation ControlView

+ (ControlView*)creatControlViewWithImageName:(NSString*)imageName withDelegate:(id)delegate{
    
    ControlView *controlView = [[ControlView alloc] initWithImageName:imageName withDelegate:delegate];
    
    return controlView;
}

- (id)initWithImageName:(NSString*)imageName withDelegate:(id)delegate{
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    _theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    self.frame = _theImageView.frame;
    
    [self addImageView];
   
    
    
    self.delegate = delegate;
//    self.backgroundColor = [UIColor grayColor];
    
    return self;
}



- (void)addImageView{
    
    [self addSubview:_theImageView];
    
    [_theImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint_Top = [NSLayoutConstraint constraintWithItem:_theImageView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0];
    
    NSLayoutConstraint *constraint_Buttom = [NSLayoutConstraint constraintWithItem:_theImageView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *constraint_Left = [NSLayoutConstraint constraintWithItem:_theImageView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:0];
    
    NSLayoutConstraint *constraint_Right = [NSLayoutConstraint constraintWithItem:_theImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:0];
    
    [self addConstraints:@[constraint_Top,constraint_Buttom,constraint_Left,constraint_Right]];
    
    _theImageView.layer.cornerRadius = (_theImageView.frame.size.width+_theImageView.frame.size.height)/4;
    _theImageView.clipsToBounds = YES;
    
    
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Start Selector");
    [self.delegate controlView:self didBeginTouch:touches];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Move...");
    [self.delegate controlView:self didMoveTouch:touches];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Select Done");
    [self.delegate controlView:self didStopTouch:touches];
    
}





@end
