//
//  KWPMainViewController.h
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KWPMainViewDelegate <NSObject>

-(CGRect)viewSize;

@end

@interface KWPMainViewController : UIViewController

@property (strong, nonatomic) UIViewController *contentViewController;
@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) id<KWPMainViewDelegate> contentDelegate;

@end
