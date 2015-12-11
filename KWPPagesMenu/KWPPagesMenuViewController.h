//
//  KWPPagesMenuViewController.h
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KWPPagesMenuDatasource <NSObject>

- (UIView*) pageSnapShot;

@end

@interface KWPPagesMenuViewController : UIViewController

@property (strong, nonatomic) NSMutableArray<UIViewController *> *pageViews;
@property (strong, nonatomic) NSMutableArray<id<KWPPagesMenuDatasource>> *datasource;

@property (nonatomic, readonly) CGFloat subviewW;
@property (nonatomic) NSInteger tagCount;
@property (nonatomic) CGFloat pageMarginY;
@property (nonatomic) CGFloat pageLabelRightMargin;


-(CGFloat)subPageViewY:(NSInteger)num;
-(CGFloat)subPageViewX:(NSInteger)num;

@end
