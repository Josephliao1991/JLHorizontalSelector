//
//  JLHorizontalSelector.m
//  JLHorizontalSelector
//
//  Created by TSUNG-LUN LIAO on 2015/6/12.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import "JLHorizontalSelector.h"
#import "DataModel.h"
#import "ControlView.h"

@interface JLHorizontalSelector () <UITableViewDelegate,UITableViewDataSource,ControlViewDelegate>
@property (nonatomic, strong)id<JLHorizontalSelectorDelegate> delegate;

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *data;

@property (nonatomic, strong) UIView            *moveView;

@property (nonatomic, strong) ControlView       *controlView;
@property (nonatomic, strong) NSString          *imageName;

@end

@implementation JLHorizontalSelector

+ (JLHorizontalSelector*)creatSeletcorWithObjects:(NSArray*)objects withStartImageName:(NSString *)imageName  withDelegate:(id)delegate{
    
    JLHorizontalSelector *selector = [[JLHorizontalSelector alloc] initWithWithObjects:objects
                                                                         withImageName:imageName
                                                                          withDelegate:delegate];
    
    return selector;
    
}

- (id)initWithWithObjects:(NSArray*)objects withImageName:(NSString*)imageName withDelegate:(id)delegate{
    
    //size set
    CGSize size = CGSizeMake([(UIViewController*)delegate view].frame.size.width,
                             [(UIViewController*)delegate view].frame.size.height);
    
    self = [super initWithFrame:CGRectMake(-size.width/3,
                                           0,
                                           size.width/3,
                                           size.height)];
    //set delegate
    self.delegate = delegate;
    
    
    //set data
    self.data = [[NSMutableArray alloc]init];
    
    for (NSDictionary* dic in objects) {
        
        [self.data addObject:[[DataModel alloc] initWithTitle:[dic objectForKey:@"title"]]];
        
    }
    
    _imageName = imageName;
    
    //set MoveView ...
    _moveViewColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.4 alpha:0.7];
    _moveViewSize = CGSizeMake(60, 60);
    
    //set item
    _itemColor  = [UIColor colorWithRed:0.1 green:0.2 blue:0.4 alpha:0.9];
    _titleColor = [UIColor whiteColor];
    
    //set selector animation type
    _animation = selectorDirectionAlpha;
    
    //set selector direction
    _direction = selectorDirectionUp;
    
    //Notification setting
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetView)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    
    return self;
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)show{
    
    [[(UIViewController*)self.delegate view] addSubview:self];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    NSLayoutConstraint *constraint_Top = [NSLayoutConstraint constraintWithItem:self
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:[(UIViewController*)self.delegate view]
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0];
    
    NSLayoutConstraint *constraint_Buttom = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:[(UIViewController*)self.delegate view]
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *constraint_Width = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:[(UIViewController*)self.delegate view]
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:0.333
                                                                          constant:0];
    
    NSLayoutConstraint *constraint_LeftMergin = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:[(UIViewController*)self.delegate view]
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0
                                                                         constant:-self.frame.size.width*2];
    
    
    [[(UIViewController*)self.delegate view] addConstraints:@[constraint_Top,constraint_Buttom,constraint_Width,constraint_LeftMergin]];
    
    
    [self addTableView];
    [self addMoveView];
    [self addControlView];
    
}

#pragma mark - Add SubView
- (void)addTableView{
    

    
    CGRect rect = CGRectMake(0, 0,self.frame.size.width, [_data count]*21);
    
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.userInteractionEnabled = false;
    _tableView.center = self.center;
    
    [self addSubview:_tableView];
    
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint_Top = [NSLayoutConstraint constraintWithItem:_tableView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:rect.size.height];
    
    NSLayoutConstraint *constraint_Buttom = [NSLayoutConstraint constraintWithItem:_tableView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:rect.size.height];
    
    NSLayoutConstraint *constraint_Left = [NSLayoutConstraint constraintWithItem:_tableView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:0];
    
    NSLayoutConstraint *constraint_Right = [NSLayoutConstraint constraintWithItem:_tableView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:0];
    
    [self addConstraints:@[constraint_Top,constraint_Buttom,constraint_Left,constraint_Right]];


    
}

- (void)addControlView{
    

    _controlView = [ControlView creatControlViewWithImageName:_imageName withDelegate:self];
    [[(UIViewController*)self.delegate view] addSubview:_controlView];
    
    [_controlView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint_Buttom = [NSLayoutConstraint constraintWithItem:_controlView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:[(UIViewController*)self.delegate view]
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:-5];
    
    NSLayoutConstraint *constraint_Left = [NSLayoutConstraint constraintWithItem:_controlView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[(UIViewController*)self.delegate view]
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:5];
    
    [[(UIViewController*)self.delegate view] addConstraints:@[constraint_Buttom,constraint_Left]];

}

- (void)addMoveView{
    
        
        //Set Size
        _moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _moveViewSize.width, _moveViewSize.height)];
        _moveView.layer.cornerRadius = (_moveViewSize.width+_moveViewSize.height)/4;
        
        _moveView.backgroundColor = _moveViewColor;
        _moveView.alpha = 0;
        
        
        
        [[(UIViewController*)_delegate view] addSubview:_moveView];

}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell*cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.textColor = _titleColor;
    
    DataModel *data = _data[indexPath.row];
    cell.textLabel.text = data.title;
    

    cell.backgroundColor = _itemColor;

    
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

#pragma mark - ControlViewDelegate
- (void)controlView:(ControlView *)controlView didBeginTouch:(NSSet *)touches{
    
    
    CGPoint point = [touches.anyObject locationInView:[(UIViewController*)_delegate view]];
    _moveView.center = point;
    
    [UIView animateWithDuration:0.3 animations:^{
        //
        self.frame = CGRectMake(0, 0,
                                self.frame.size.width,
                                self.frame.size.height);
        
        self.moveView.alpha = 1;
        
        self.controlView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        //
        //set selector up to down or up to down
        NSInteger row = 0;
        if (_direction == selectorDirectionUp) {
            row = [_data count]-1;
        }
        
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
        
    }];

    
}

- (void)controlView:(ControlView *)controlView didMoveTouch:(NSSet *)touches{
    
    NSInteger index = [self IndexOfItemWithTouches:touches];
    
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                            animated:YES
                      scrollPosition:UITableViewScrollPositionTop];
    
    CGPoint point = [touches.anyObject locationInView:[(UIViewController*)_delegate view]];
    self.moveView.center = point;
    
    //set animation
    [self selectorAnimationWithTouches:touches];
    
    
}

- (void)controlView:(ControlView *)controlView didStopTouch:(NSSet *)touches{
    
    NSInteger index = [self IndexOfItemWithTouches:touches];
    
    [self.delegate horizontalSelector:self didSelectItemOfIndex:index];
    
    [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                              animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        //
        self.frame = CGRectMake(-self.frame.size.width, 0,
                                self.frame.size.width,
                                self.frame.size.height);
        
        self.moveView.alpha = 0;
        self.controlView.alpha = 1;
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        //
        self.moveView.center = self.controlView.center;
    }];
    
}
#pragma mark - Clean View Method
- (void)resetView{
    
    self.frame = CGRectMake(-self.frame.size.width, 0,
                            self.frame.size.width,
                            self.frame.size.height);
    
    self.moveView.alpha = 0;
    self.controlView.alpha = 1;
    self.alpha = 1;

    self.moveView.center = self.controlView.center;
    
}

#pragma  mark - Index Cacluate

- (NSInteger)IndexOfItemWithTouches:(NSSet*)touches{
    
    CGPoint point           = [touches.anyObject locationInView:[(UIViewController*)_delegate view]];
    
//    NSInteger index = (point.x - _controlView.frame.size.width)/(self.frame.size.width*2)*((int)[_data count]+1);
//      |           |
//    /*|-----------|*\
//      |          /|
//      |        /  |
//  (1)*|------/    | (2)
//      |    / |    |
//      |  /   |    |
//    \*|/_____|____|*/
//    (１／４斜邊長 比例 移動)
    
    NSInteger indexR =
    (hypot(point.x,([(UIViewController*)_delegate view].frame.size.height-point.y))//(1)
     - _controlView.frame.size.width)/ // - controlView self with
    (hypot([(UIViewController*)_delegate view].frame.size.width, [(UIViewController*)_delegate view].frame.size.height/2))*//(2)
    ((int)[_data count]+1)*2;//(itme index X 2)--> 1/2 to 1/4;
    
    if (indexR+1 > [_data count]) {
        indexR = [_data count]-1;
    }else if (indexR < 0){
        indexR = 0;
    }
    
    //set selector up to down or down to up
    if (_direction == selectorDirectionUp) {
        
        indexR = [_data count] - indexR -1;
        
    }
    
    
    NSLog(@"Now Select Index %ld",(long)indexR);
    
    return indexR;
}

#pragma  mark - Selector Animation 
- (void)selectorAnimationWithTouches:(NSSet*)touches{
    
    if (_animation == selectorDirectionNone) {
        return;
    }
    
    if (_animation == selectorDirectionAlpha) {
        
        //Alpha animation
        
        CGPoint point = [touches.anyObject locationInView:[(UIViewController*)_delegate view]];
        CGPoint previousPoint = [touches.anyObject previousLocationInView:[(UIViewController*)_delegate view]];
        
            float alphaRate_w = 1.25/[(UIViewController*)_delegate view].frame.size.width;
            float alphaRate_h = 0.75/[(UIViewController*)_delegate view].frame.size.height;
        
//        float alphaRate = (hypot(point.x,(self.frame.size.height/2-point.y/2)) - _controlView.frame.size.width)/(hypot(self.frame.size.width, self.frame.size.height/2))/[(UIViewController*)_delegate view].frame.size.height;
        
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
    
//    if (_animation == ) {
//        
//    }
    
}


@end
