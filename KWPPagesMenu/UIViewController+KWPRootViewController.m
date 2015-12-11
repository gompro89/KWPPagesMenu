//
//  UIViewController+KWPRootViewController.m
//  KWPMenuController
//
//  Created by 朴 根佑 on 2015/12/07.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import "UIViewController+KWPRootViewController.h"

@implementation UIViewController (KWPRootViewController)

-(KWPRootViewController *)rootViewController
{
    UIViewController *iter = self.parentViewController;
    
    if ([iter isKindOfClass:[KWPRootViewController class]])
        return (KWPRootViewController * )iter;
    else if (iter.parentViewController && iter.parentViewController != iter)
        iter = iter.parentViewController;
    else
        iter = nil;

    return nil;
}

@end
