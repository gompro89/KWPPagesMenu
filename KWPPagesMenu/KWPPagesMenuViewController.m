//
//  KWPPagesMenuViewController.m
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import "KWPPagesMenuViewController.h"
#import "PageSubViewHeaders.h"
#import "KWPMainViewController.h"

#define subviewY(num) self.pageMarginY * (self.tagCount - (num))
#define subviewX(num) self.subviewW *  - (self.tagCount - (num))

@interface KWPPagesMenuViewController ()
@end

@implementation KWPPagesMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initPagesMenuView];
    
    
    [self setPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark init

-(void)initPagesMenuView
{
    self.tagCount = NonValue;
    self.pageMarginY = NonValue;
    self.pageLabelRightMargin = NonValue;
}

#pragma mark -
#pragma mark make PageSubViews

-(void)setPageSubviews
{
    NSMutableArray<UIViewController*> * pageSubViews = [[NSMutableArray<UIViewController*> alloc] init];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewA"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewB"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewC"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewD"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewE"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewA"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewB"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewC"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewD"]];
    [pageSubViews addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageSubViewE"]];
    [self setPageViews:pageSubViews];
}

#pragma mark -
#pragma mark properties Setter

-(CGFloat)subviewW
{
    KWPMainViewController *mainViewVC = (KWPMainViewController*)self.rootViewController.mainPageController;
    
    return CGRectGetWidth(mainViewVC.view.frame)/(self.tagCount+1);
}

-(NSInteger)tagCount
{
    if (_tagCount == NonValue) {
        _tagCount = 7;
    }
    
    return _tagCount;
}

-(CGFloat)pageMarginY
{
    if (_pageMarginY == NonValue) {
        _pageMarginY = 50.f;
    }
    
    return _pageMarginY;
}

-(CGFloat)pageLabelRightMargin
{
    if (_pageLabelRightMargin == NonValue) {
        _pageLabelRightMargin = 10.f;
    }
    
    return _pageLabelRightMargin;
}

-(CGFloat)subPageViewX:(NSInteger)num
{
    return subviewX(num);
}

-(CGFloat)subPageViewY:(NSInteger)num
{
    return subviewY(num);
}

#pragma mark -
#pragma mark KWPRootViewDelegate

- (CGRect) viewSize
{
    [self.view layoutIfNeeded];
    
    if ([self.rootViewController pagesMenuOpen])
        return KWPPagesMenuViewFrameCalculate(KWPRoot.maxMenuPer);
    else
        return KWPPagesMenuViewFrameCalculate(KWPRoot.minMenuPer);

}

- (void)setPageViews:(NSMutableArray<UIViewController *> *)pageViews
{
    [self.view layoutIfNeeded];
   
    _pageViews = [[NSMutableArray<UIViewController *> alloc] init];
    self.datasource = [[NSMutableArray<id<KWPPagesMenuDatasource>> alloc] init];
    
    for (int i = 0 ; i < self.tagCount; i++) {
               
        CGFloat tmpX = subviewX(i);
        CGFloat tmpY = subviewY(i);
        
//        CGFloat tmpX = i == 0 ? 0 :subviewX(i);
//        CGFloat tmpY = i == 0 ? 0 :subviewY(i);
        
//        NSLog(@"%f",tmpX);
        
        UIViewController *tmpCV = [pageViews objectAtIndex:i];
//        if (_mainPageController) {
            [tmpCV willMoveToParentViewController:nil];
            [tmpCV removeFromParentViewController];
            [tmpCV.view removeFromSuperview];
//        }
        
//        if (!_mainPageController)
//            return;
        
        id<KWPPagesMenuDatasource> tmpCVDelegate = (id<KWPPagesMenuDatasource>)tmpCV;
        [self.datasource addObject:tmpCVDelegate];
        
        [self addChildViewController:tmpCV];
        [_pageViews addObject:tmpCV];
        
        KWPMainViewController *mainViewVC = (KWPMainViewController*)self.rootViewController.mainPageController;
        
        tmpCV.view.frame = CGRectMake( tmpX, tmpY, CGRectGetWidth(mainViewVC.view.frame), CGRectGetHeight(mainViewVC.view.frame));
        
        //    NSLog(@" Content %@",NSStringFromCGRect(_contentController.view.frame));
        tmpCV.view.clipsToBounds = YES;
        
        [self.view insertSubview:tmpCV.view atIndex:0];
        [tmpCV didMoveToParentViewController:self];
        
    }
    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
    
}


- (void) setSubViewsLayout
{

}

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation
{

}


@end
