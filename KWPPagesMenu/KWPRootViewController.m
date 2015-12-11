//
//  KWPRootViewController.m
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import "KWPRootViewController.h"
#import "KWPPagesMenuViewController.h"

@interface KWPRootViewController ()
{
    
    CGRect originalMenuFrame;
    CGRect originalContentFrame;
    
    UIView* mainViewSnapShot;

}
@end

@implementation KWPRootViewController
@synthesize panGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    //panGesture
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    [self rootViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark init

-(void)rootViewInit
{
    self.pagesMenuOpen = NO;
    
    self.totalPer = NonValue;
    self.minMenuPer = NonValue;
    self.maxMenuPer = NonValue;
}



#pragma mark -
#pragma mark Property Setter

- (BOOL) pagesMenuOpen
{
    
    //layout設定
    return _pagesMenuOpen;
}

- (CGFloat) totalPer
{
    if (_totalPer == NonValue) {
        _totalPer = 9;
    }
    
    return _totalPer;
}

- (CGFloat) minMenuPer
{
    if (_minMenuPer == NonValue) {
        _minMenuPer = 0;
    }
    
    return _minMenuPer;
}

- (CGFloat) maxMenuPer
{
    if (_maxMenuPer == NonValue) {
        _maxMenuPer = 9;
    }
    
    return _maxMenuPer;
}

- (void)setMainPageController:(UIViewController *)mainPageController{
    
    [self.view layoutIfNeeded];
    
    if (_mainPageController) {
        [_mainPageController willMoveToParentViewController:nil];
        [_mainPageController removeFromParentViewController];
        [_mainPageController.view removeFromSuperview];
    }
    
    _mainPageController = mainPageController;
    
    if (!_mainPageController)
        return;
    
    id<KWPRootViewDelegate> mainPageDelegate = (id<KWPRootViewDelegate>)_mainPageController;
    _mainPageDelegate = mainPageDelegate;
    
    [self addChildViewController:_mainPageController];
    _mainPageController.view.frame = [_mainPageDelegate viewSize];
    
    //    NSLog(@" Content %@",NSStringFromCGRect(_contentController.view.frame));
    _mainPageController.view.clipsToBounds = YES;
    
    [self.view addSubview:_mainPageController.view];
    [_mainPageController didMoveToParentViewController:self];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
}

- (void)setPagesMenuController:(UIViewController *)pagesMenuController{
    
    [self.view layoutIfNeeded];
    
    if (_pagesMenuController) {
        [_pagesMenuController willMoveToParentViewController:nil];
        [_pagesMenuController removeFromParentViewController];
        [_pagesMenuController.view removeFromSuperview];
    }
    
    _pagesMenuController = pagesMenuController;
    
    if (!_pagesMenuController)
        return;
    
    id<KWPRootViewDelegate> pagesMenuDelegate = (id<KWPRootViewDelegate>)_pagesMenuController;
    _pagesMenuDelegate = pagesMenuDelegate;
    
    [self addChildViewController:_pagesMenuController];
    _pagesMenuController.view.frame = [_pagesMenuDelegate viewSize];
    
    //    NSLog(@" Content %@",NSStringFromCGRect(_contentController.view.frame));
    _pagesMenuController.view.clipsToBounds = YES;
    
    [self.view addSubview:_pagesMenuController.view];
    [_pagesMenuController didMoveToParentViewController:self];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    
    if ([_pagesMenuController respondsToSelector:@selector(setSubViewsLayout)]) {
        
        [_pagesMenuDelegate setSubViewsLayout];
    }
}



#pragma mark -
#pragma mark gesture

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    
    NSLog(@" menuView %@",NSStringFromCGRect(self.mainPageController.view.frame));
    
    NSLog(@" contentView %@",NSStringFromCGRect(self.pagesMenuController.view.frame));
    
    CGPoint location = [recognizer locationInView:self.view];
    if (CGRectContainsPoint(self.pagesMenuController.view.frame, location)) {
        NSLog(@"self.menuView contain ||| location → %@ ", NSStringFromCGPoint(location));
    }else if (CGRectContainsPoint(self.mainPageController.view.frame, location)) {
        NSLog(@"self.contentView contain ||| location → %@ ", NSStringFromCGPoint(location));
    }else{
        NSLog(@"not contain location → %@ ", NSStringFromCGPoint(location));
    }
    
    CGPoint point = [recognizer translationInView:self.view];
    
    CGRect tmpMenuRect = self.pagesMenuController.view.frame;
    CGRect tmpContentRect = self.mainPageController.view.frame;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@" start →　%@",NSStringFromCGPoint(point));
        
        originalMenuFrame = CGRectNull;
        originalContentFrame = CGRectNull;
        
        
        originalMenuFrame = tmpMenuRect;
        originalContentFrame = tmpContentRect;
     
        if ([self.pagesMenuController isKindOfClass:[KWPPagesMenuViewController class]]) {
            [self tagMenuPanGestureBegan:recognizer];
        }
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@" change →　%@",NSStringFromCGPoint(point));
        
        tmpMenuRect.origin.x = originalMenuFrame.origin.x + point.x;
        tmpContentRect.origin.x = originalContentFrame.origin.x + point.x;
        
        if (tmpContentRect.origin.x >= -((CGRectGetWidth(self.view.frame)/self.totalPer) * (self.maxMenuPer - self.minMenuPer))
            && tmpContentRect.origin.x <= 0) {
            self.mainPageController.view.frame = tmpContentRect;
            self.pagesMenuController.view.frame = tmpMenuRect;
        }else{
            return;
        }
        
        if ([self.pagesMenuController isKindOfClass:[KWPPagesMenuViewController class]]) {
            [self tagMenuPanGestureChanged:recognizer pagesMenuRect:tmpMenuRect mainViewRect:tmpContentRect];
        }
    }
    
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@" end →　%@",NSStringFromCGPoint(point));
        
        NSLog(@"CGRectGetMidX(tmpMenuRect)/2 : %f",CGRectGetMidX(tmpMenuRect));
        NSLog(@"CGRectGetMaxX(self.view.frame) : %f",CGRectGetMaxX(self.view.frame));
        
        if (CGRectGetMidX(tmpMenuRect) > CGRectGetMaxX(self.view.frame)) {
            [self setPagesMenuOpen:NO];
        }else{
            [self setPagesMenuOpen:YES];
        }
        
        
        if ([self.pagesMenuController isKindOfClass:[KWPPagesMenuViewController class]]) {
            [self tagMenuPanGestureEnded:recognizer];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutMultiView];
        }];
        
    }
}

#pragma mark -
#pragma mark setLayout
- (void) layoutMultiView
{
    self.mainPageController.view.frame  = [self.mainPageDelegate viewSize];
    self.pagesMenuController.view.frame = [self.pagesMenuDelegate viewSize];
}


#pragma mark -
#pragma mark Tag Menu PanGesture

-(void)tagMenuPanGestureBegan:(UIPanGestureRecognizer *)recognizer
{
    
    if(mainViewSnapShot != nil)
        return;
    
    
    mainViewSnapShot = (UIImageView*)[self.mainPageController.view snapshotViewAfterScreenUpdates:NO];
    [self.view addSubview:mainViewSnapShot];
    
    [self.mainPageController.view setBackgroundColor:[UIColor whiteColor]];
    
}

-(void)tagMenuPanGestureChanged:(UIPanGestureRecognizer *)recognizer pagesMenuRect:(CGRect)pagesMenuRect mainViewRect:(CGRect)mainViewRect
{
    KWPPagesMenuViewController *pagesMenuCV = (KWPPagesMenuViewController*)self.pagesMenuController;
    
    CGRect snapShotFrame = mainViewSnapShot.frame;
    CGFloat calculateMainViewY =(-mainViewRect.origin.x)/((CGRectGetWidth(self.view.frame)/self.totalPer)* (self.maxMenuPer-self.minMenuPer));
    calculateMainViewY *= [pagesMenuCV subPageViewY:0];
    snapShotFrame.origin.y = calculateMainViewY;

    
    UIView *tmpFirstView = [pagesMenuCV.pageViews firstObject].view;
    
    CGRect convertFrame = [self.view convertRect:self.view.frame fromView:tmpFirstView];
    
    NSLog(@"convertFrame : %@", NSStringFromCGRect(convertFrame));
    NSLog(@"convertFrame Max : %f",CGRectGetMaxX(convertFrame));
    
    if (CGRectGetMaxX(convertFrame) <= CGRectGetWidth(self.view.frame)) {
        
        snapShotFrame.origin.x = CGRectGetMaxX(convertFrame) - snapShotFrame.size.width ;
        
    }
    
//    [self.pagesMenuDelegate menuPanGestureStateChanged:recognizer];
    
    mainViewSnapShot.frame = snapShotFrame;
}

-(void)tagMenuPanGestureEnded:(UIPanGestureRecognizer *)recognizer{
    KWPPagesMenuViewController *pagesMenuCV = (KWPPagesMenuViewController*)self.pagesMenuController;
    
    CGRect snapShotFrame = mainViewSnapShot.frame;
    
    if ([self pagesMenuOpen]) {
        snapShotFrame.origin.x = (CGRectGetWidth(pagesMenuCV.view.frame)/(pagesMenuCV.tagCount+1)) * -pagesMenuCV.tagCount;
        snapShotFrame.origin.y = [pagesMenuCV subPageViewY:0];
    }else{
        snapShotFrame.origin.x = 0;
        snapShotFrame.origin.y = 0;
    }
    
    [UIView animateWithDuration:.25f animations:^{
        mainViewSnapShot.frame = snapShotFrame;
        
//        [self.pagesMenuDelegate menuPanGestureStateEnded:recognizer];
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
