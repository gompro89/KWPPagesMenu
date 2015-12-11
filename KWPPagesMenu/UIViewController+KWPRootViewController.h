//
//  UIViewController+KWPRootViewController.h
//  KWPMenuController
//
//  Created by 朴 根佑 on 2015/12/07.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWPRootViewController.h"

#define KWPRoot self.rootViewController

#define KWPMainViewFrameCalculate(mp) CGRectMake(-(CGRectGetWidth(KWPRoot.view.frame)/KWPRoot.totalPer)* ((mp)-KWPRoot.minMenuPer), 0, (CGRectGetWidth(KWPRoot.view.frame)/KWPRoot.totalPer)*(KWPRoot.totalPer-KWPRoot.minMenuPer), CGRectGetHeight(KWPRoot.view.frame))

#define KWPPagesMenuViewFrameCalculate(mp) CGRectMake(CGRectGetMaxX(KWPMainViewFrameCalculate(mp)), 0, (CGRectGetWidth(KWPRoot.view.frame)/KWPRoot.totalPer)*(KWPRoot.maxMenuPer), CGRectGetHeight(KWPRoot.view.frame))

@interface UIViewController (KWPRootViewController)

@property (strong, readonly, nonatomic) KWPRootViewController *rootViewController;

@end
