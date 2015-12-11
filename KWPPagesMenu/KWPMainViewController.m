//
//  KWPMainViewController.m
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import "KWPMainViewController.h"

@interface KWPMainViewController ()

@end

@implementation KWPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    self.view.layer.masksToBounds = NO;
    self.view.layer.cornerRadius = 8; // if you like rounded corners
    self.view.layer.shadowOffset = CGSizeMake(-10, -10); // 上向きの影
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark -
#pragma mark KWPRootViewDelegate

- (CGRect) viewSize
{
    [self.view layoutIfNeeded];
    
    if ([self.rootViewController pagesMenuOpen])
        return KWPMainViewFrameCalculate(KWPRoot.maxMenuPer);
    else
        return KWPMainViewFrameCalculate(KWPRoot.minMenuPer);
}

- (void) setSubViewsLayout
{
  
}

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation
{

}


@end
