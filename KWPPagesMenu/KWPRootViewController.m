//
//  KWPRootViewController.m
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import "KWPRootViewController.h"
#import "KWPPagesMenuViewController.h"
#import "KWPMainViewController.h"

@interface KWPRootViewController ()
{
    
    CGRect originalMenuFrame;
    CGRect originalContentFrame;
    
    UIView* mainViewSnapShot;
    
    UIView* subViewsSnapshot;
    
    UIView* mainViewBackGroundView;

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

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.selectedPageNum) {
        self.selectedPageNum = 0;
    }
    [self setContentInMainView];
}

-(void)setContentInMainView
{
    KWPMainViewController *mainViewCV = (KWPMainViewController*)self.mainPageController;
    KWPPagesMenuViewController *pagesMenuCV = (KWPPagesMenuViewController*)self.pagesMenuController;
    mainViewCV.contentViewController = [pagesMenuCV.pageViews objectAtIndex:self.selectedPageNum];
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
        _totalPer = 1;
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
        _maxMenuPer = _totalPer;
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
    
    // シングルタップ
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapGesture:)];
    [_pagesMenuController.view addGestureRecognizer:tapGesture];
    
    
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
    
//    NSLog(@" menuView %@",NSStringFromCGRect(self.mainPageController.view.frame));
    
//    NSLog(@" contentView %@",NSStringFromCGRect(self.pagesMenuController.view.frame));
    
    CGPoint location = [recognizer locationInView:self.view];
    if (CGRectContainsPoint(self.pagesMenuController.view.frame, location)) {
//        NSLog(@"self.menuView contain ||| location → %@ ", NSStringFromCGPoint(location));
    }else if (CGRectContainsPoint(self.mainPageController.view.frame, location)) {
//        NSLog(@"self.contentView contain ||| location → %@ ", NSStringFromCGPoint(location));
    }else{
//        NSLog(@"not contain location → %@ ", NSStringFromCGPoint(location));
    }
    
    CGPoint point = [recognizer translationInView:self.view];
    
    CGRect tmpMenuRect = self.pagesMenuController.view.frame;
    CGRect tmpContentRect = self.mainPageController.view.frame;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@" start →　%@",NSStringFromCGPoint(point));
        
        originalMenuFrame = CGRectNull;
        originalContentFrame = CGRectNull;
        
        
        originalMenuFrame = tmpMenuRect;
        originalContentFrame = tmpContentRect;
     
        if ([self.pagesMenuController isKindOfClass:[KWPPagesMenuViewController class]]) {
            [self tagMenuPanGestureBegan:recognizer];
        }
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@" change →　%@",NSStringFromCGPoint(point));
        
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
//        NSLog(@" end →　%@",NSStringFromCGPoint(point));
        
//        NSLog(@"CGRectGetMidX(tmpMenuRect)/2 : %f",CGRectGetMidX(tmpMenuRect));
//        NSLog(@"CGRectGetMaxX(self.view.frame) : %f",CGRectGetMaxX(self.view.frame));
        
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

    if (mainViewBackGroundView == nil) {
        mainViewBackGroundView = [[UIView alloc] initWithFrame:self.mainPageController.view.frame];
        [mainViewBackGroundView setBackgroundColor:self.mainPageController.view.backgroundColor];
        [self.mainPageController.view addSubview:mainViewBackGroundView];
    }
    
    if (mainViewSnapShot == nil) {
        mainViewSnapShot = [self pb_takeSnapshot:self.mainPageController.view];
        [self.view addSubview:mainViewSnapShot];
    }
    mainViewSnapShot.alpha = 1;
    
    [self reloadPagesMenuView:YES];
    
    [self makeSubViewsSnapShotImageInMainView];
}

- (UIImageView *)pb_takeSnapshot:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:[image copy]];
}

-(void)makeSubViewsSnapShotImageInMainView
{
    KWPPagesMenuViewController *pagesMenuCV = (KWPPagesMenuViewController*)self.pagesMenuController;
    
    if (subViewsSnapshot) {
        [subViewsSnapshot removeFromSuperview];
        subViewsSnapshot = nil;
    }
    
    subViewsSnapshot = [[UIView alloc] initWithFrame:self.view.frame];
    [subViewsSnapshot setBackgroundColor:[UIColor clearColor]];
    for (int i = 0; i < pagesMenuCV.tagCount; i++) {
        
        UIView *tmpView =[[pagesMenuCV.pageViews objectAtIndex:i].view snapshotViewAfterScreenUpdates:NO];
        CGRect tmpFrame = tmpView.frame;
        
        tmpFrame.origin.x = (CGRectGetWidth(pagesMenuCV.view.frame)/(pagesMenuCV.tagCount+1)) * (i+1);
        tmpFrame.origin.y = [pagesMenuCV subPageViewY:i];
        
        tmpView.frame = tmpFrame;
        
        if (tmpView != nil) {
            if (i != self.selectedPageNum) {
                 [subViewsSnapshot insertSubview:tmpView atIndex:0];
            }
           
        }
        
    }
    
    [self.mainPageController.view addSubview:subViewsSnapshot];
}


-(void)tagMenuPanGestureChanged:(UIPanGestureRecognizer *)recognizer pagesMenuRect:(CGRect)pagesMenuRect mainViewRect:(CGRect)mainViewRect
{
    KWPPagesMenuViewController *pagesMenuCV = (KWPPagesMenuViewController*)self.pagesMenuController;
    
    CGRect snapShotFrame = mainViewSnapShot.frame;
    
    CGFloat openPercent = (-mainViewRect.origin.x)/((CGRectGetWidth(self.view.frame)/self.totalPer)* (self.maxMenuPer-self.minMenuPer));
    CGFloat calculateMainViewSnapshotY = openPercent * [pagesMenuCV subPageViewY:self.selectedPageNum];
    snapShotFrame.origin.y = calculateMainViewSnapshotY;
    
    UIView *tmpFirstView = [pagesMenuCV.pageViews objectAtIndex:self.selectedPageNum].view ;
    CGRect convertFrame = [self.view convertRect:self.view.frame fromView:tmpFirstView];
    
  
    if ([self pagesMenuOpen]) {
        mainViewSnapShot.alpha = 1 - openPercent;
    }else{
        mainViewSnapShot.alpha = openPercent;
    }

    CGFloat calculateMainViewSnapshotX = CGRectGetMinX(tmpFirstView.frame) * openPercent;
    snapShotFrame.origin.x =  calculateMainViewSnapshotX;
    
    NSLog(@"tmpFirstView %@",NSStringFromCGRect(tmpFirstView.frame));
    NSLog(@"convertFrame %@",NSStringFromCGRect(convertFrame));
    NSLog(@" ");
    
    if(snapShotFrame.origin.x < 0)
        mainViewSnapShot.frame = snapShotFrame;
    
    
    
}

-(void)tagMenuPanGestureEnded:(UIPanGestureRecognizer *)recognizer{
    KWPPagesMenuViewController *pagesMenuCV = (KWPPagesMenuViewController*)self.pagesMenuController;
    
    CGRect snapShotFrame = mainViewSnapShot.frame;
    
    if ([self pagesMenuOpen]) {
        snapShotFrame.origin.x = (CGRectGetWidth(pagesMenuCV.view.frame)/(pagesMenuCV.tagCount+1)) * -(pagesMenuCV.tagCount-self.selectedPageNum);
        snapShotFrame.origin.y = [pagesMenuCV subPageViewY:self.selectedPageNum];
    }else{
        snapShotFrame.origin.x = 0;
        snapShotFrame.origin.y = 0;
    }
    
    
    [UIView animateWithDuration:.25f animations:^{
       
        if ([self pagesMenuOpen])
            mainViewSnapShot.alpha = 0;
        else
            mainViewSnapShot.alpha = 1;
        
        mainViewSnapShot.frame = snapShotFrame;
        
    } completion:^(BOOL finished) {
    
        [self reloadPagesMenuView:NO];
    }];
    
}

- (void) menuTapGesture:(UITapGestureRecognizer*)sender {
    
    CGPoint location = [sender locationInView:self.pagesMenuController.view];
//    NSLog(@"location : %@",NSStringFromCGPoint(location));
    
    UIView *hitView = [self.pagesMenuController.view hitTest:location withEvent:UIEventTypeTouches ];
    KWPPagesMenuViewController *pagesMenu = (KWPPagesMenuViewController*)self.pagesMenuController;
    
    for (UIViewController* tmp in pagesMenu.pageViews) {
        if (tmp.view == hitView) {
            [self setPagesMenuOpen:NO];
            
            [mainViewSnapShot removeFromSuperview];
            mainViewSnapShot = nil;
            
            [mainViewBackGroundView removeFromSuperview];
            mainViewBackGroundView = nil;

            
            self.selectedPageNum = [pagesMenu.pageViews indexOfObject:tmp];
            
            __block UIImageView *tmpImageView = [self pb_takeSnapshot:tmp.view];
            NSLog(@"%@",NSStringFromCGRect([pagesMenu.pageViews objectAtIndex:self.selectedPageNum].view.frame));
            tmpImageView.frame = [pagesMenu.pageViews objectAtIndex:self.selectedPageNum].view.frame;
            [self.view addSubview:tmpImageView];
            
            [self setContentInMainView];
            self.mainPageController.view.alpha = 0;
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
                tmpImageView.frame = self.view.frame;
                [self layoutMultiView];
                
            } completion:^(BOOL finished) {
                [tmpImageView removeFromSuperview];
                tmpImageView = nil;
                
                self.mainPageController.view.alpha = 1;
            }];
            
        }
        
        if (tmp.view == nil) {
            NSLog(@"%@", [tmp description]);
            NSLog(@"aaaaaaa %@",NSStringFromCGRect(tmp.view.frame));
            
        }
    }
    NSLog(@"self.selectedPageNum %ld",(long)self.selectedPageNum);
    
    return;
    
}

#pragma mark -
#pragma mark Reload PagesMenuView
-(void)reloadPagesMenuView:(BOOL)gestureBegin
{
    [UIView animateWithDuration:0.2 animations:^{
        KWPPagesMenuViewController *pagesMenu = (KWPPagesMenuViewController*)self.pagesMenuController;
        [pagesMenu setPageViews:pagesMenu.pageViews];
        [[pagesMenu.pageViews objectAtIndex:self.selectedPageNum].view setHidden:gestureBegin];
        
    }];

}

@end
