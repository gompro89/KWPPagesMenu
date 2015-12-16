//
//  KWPRootViewController.h
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NonValue -1

@protocol KWPRootViewDelegate <NSObject>

//mainPageViewとPagesMenuViewのサイズやレイアウト及び回転する時のdelegate

- (CGRect) viewSize;

- (void) setSubViewsLayout;

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation;

@end

@interface KWPRootViewController : UIViewController

@property (strong,nonatomic) UIViewController *mainPageController;
@property (weak, nonatomic) id <KWPRootViewDelegate> mainPageDelegate;

@property (strong,nonatomic) UIViewController *pagesMenuController;
@property (weak, nonatomic) id <KWPRootViewDelegate> pagesMenuDelegate;

//menuPagesViewが開いているかをチェックするフラグ
@property (nonatomic) BOOL pagesMenuOpen;

//MainPageViewとPagesMenuViewの範囲比率を設定
@property (nonatomic) CGFloat minMenuPer;//pagesMenuOpenがNOになった時に、画面に表示される範囲比率
@property (nonatomic) CGFloat maxMenuPer;//pagesMenuOpenがYESになった時に、画面に表示される範囲比率
@property (nonatomic) CGFloat totalPer;

//gesture
@property (strong, readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;


@property NSInteger selectedPageNum;

-(void)layoutMultiView;

@end
