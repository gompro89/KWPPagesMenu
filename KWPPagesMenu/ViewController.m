//
//  ViewController.m
//  KWPPagesMenu
//
//  Created by 朴 根佑 on 2015/12/10.
//  Copyright © 2015年 KWP. All rights reserved.
//

#import "ViewController.h"

#define StoryBoardPagesMenuID       @"KWPPagesMenuViewController"
#define StoryBoardMainViewID        @"KWPMainViewController"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mainPageController = [self.storyboard instantiateViewControllerWithIdentifier:StoryBoardMainViewID];
    self.pagesMenuController = [self.storyboard instantiateViewControllerWithIdentifier:StoryBoardPagesMenuID];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
