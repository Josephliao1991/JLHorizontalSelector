//
//  ViewController.m
//  JLHorizontalSelector
//
//  Created by TSUNG-LUN LIAO on 2015/6/12.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import "ViewController.h"
#import "JLHorizontalSelector.h"

@interface ViewController ()<JLHorizontalSelectorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JLHorizontalSelector *selector = [JLHorizontalSelector creatSeletcorWithObjects:@[@{@"title":@"iPhone 1"},
                                                                                      @{@"title":@"iPhone 2"},
                                                                                      @{@"title":@"iPhone 3"},
                                                                                      @{@"title":@"iPhone 4"}]
                                                                  withStartImageName:@"Start.png"
                                                                        withDelegate:self];
    selector.titleColor = [UIColor whiteColor];
    selector.itemColor  = [UIColor colorWithRed:0.1 green:0.2 blue:0.4 alpha:0.9];
    
    selector.moveViewColor = [UIColor colorWithRed:0.15 green:0.25 blue:0.45 alpha:0.6];
    selector.moveViewSize  = CGSizeMake(65, 65);
    
    [selector show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)horizontalSelector:(JLHorizontalSelector *)horizontalSelector didSelectItemOfIndex:(NSInteger)index{
    
    NSLog(@"Select Item %ld",(long)index);
    
}

@end
